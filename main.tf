terraform {
  required_version = "1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.65.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project_group" {
  name     = "cpProjectGroup"
  location = "westus2"
}

resource "azurerm_storage_account" "project_storage_acc" {
  name                     = "projectdatastore"
  resource_group_name      = azurerm_resource_group.project_group.name
  location                 = azurerm_resource_group.project_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "statistics_db_server" {
  name                         = "statistics-sqlserver"
  resource_group_name          = azurerm_resource_group.project_group.name
  location                     = azurerm_resource_group.project_group.location
  version                      = "12.0"
  administrator_login          = var.db_admin_username
  administrator_login_password = var.db_admin_password
}

resource "azurerm_mssql_database" "statistics_db" {
  name           = "statistics-sqlserver-db"
  server_id      = azurerm_mssql_server.statistics_db_server.id
}

resource "azurerm_mssql_firewall_rule" "ms" {
  name             = "sql-server-firewall-rule"
  server_id        = azurerm_mssql_server.statistics_db_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_eventhub_namespace" "project_event_hub_ns" {
  name                = "projecteventhubns"
  location            = azurerm_resource_group.project_group.location
  resource_group_name = azurerm_resource_group.project_group.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "reddit_messages_event_hub" {
  name                = "redditMessagesTopic"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  resource_group_name = azurerm_resource_group.project_group.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "language_detector_group" {
  name                = "language-detector-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group.name
}

resource "azurerm_eventhub_consumer_group" "sentiment_analyzer_group" {
  name                = "sentiment-analyzer-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group.name
}

resource "azurerm_eventhub_consumer_group" "keywords_extractor_group" {
  name                = "keywords-extractor-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group.name
}

resource "azurerm_app_service_plan" "project_funcs_service_plan" {
  name                = "azure-functions-service-plan"
  location            = azurerm_resource_group.project_group.location
  resource_group_name = azurerm_resource_group.project_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_application_insights" "funcs_app_insights" {
  name                = "funcs-app-insights"
  location            = "${azurerm_resource_group.project_group.location}"
  resource_group_name = "${azurerm_resource_group.project_group.name}"
  application_type    = "web"
}

resource "azurerm_function_app" "statistics_analizer_funcs" {
  name                       = "statistics-analizer-funcs"
  location                   = azurerm_resource_group.project_group.location
  resource_group_name        = azurerm_resource_group.project_group.name
  app_service_plan_id        = azurerm_app_service_plan.project_funcs_service_plan.id
  storage_account_name       = azurerm_storage_account.project_storage_acc.name
  storage_account_access_key = azurerm_storage_account.project_storage_acc.primary_access_key
  version = "~3"

  site_config {
      always_on = true
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.funcs_app_insights.instrumentation_key}"
    "EventHubConnectionString" = "${azurerm_eventhub_namespace.project_event_hub_ns.default_primary_connection_string}",
    "StatisticsDBConnectionString" = "${var.db_connection_string}"
  }

  connection_string {
    name = "ProjectdatastoreConnectionString"
    type = "Custom"
    value = var.acc_store_connection_string
  }
}

resource "azurerm_app_service_plan" "web_app_service_plan" {
  name                = "web_app_service_plan"
  location            = azurerm_resource_group.project_group.location
  resource_group_name = azurerm_resource_group.project_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "statistics_aggregator_app_service" {
  name                = "statistics-aggregator-app-service"
  location            = azurerm_resource_group.project_group.location
  resource_group_name = azurerm_resource_group.project_group.name
  app_service_plan_id = azurerm_app_service_plan.web_app_service_plan.id

  connection_string {
    name  = "StatisticsDBConnectionString"
    type  = "SQLServer"
    value = var.db_connection_string
    #value = "Server=tcp:${azurerm_mssql_database.statistics_db.fully_qualified_domain_name} Database=${azurerm_mssql_database.statistics_db.name};User ID=${var.db_admin_username};Password=${var.db_admin_password};Trusted_Connection=False;Encrypt=True;"
  }
}