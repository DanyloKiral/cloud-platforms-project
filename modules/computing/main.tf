resource "azurerm_resource_group" "project_group_computing" {
  name     = "cpProjectGroup_Computing"
  location = "westus2"
}

resource "azurerm_app_service_plan" "project_funcs_service_plan" {
  name                = "azure-functions-service-plan"
  location            = azurerm_resource_group.project_group_computing.location
  resource_group_name = azurerm_resource_group.project_group_computing.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_application_insights" "funcs_app_insights" {
  name                = "funcs-app-insights"
  location            = azurerm_resource_group.project_group_computing.location
  resource_group_name = azurerm_resource_group.project_group_computing.name
  application_type    = "web"
}

resource "azurerm_function_app" "statistics_analizer_funcs" {
  name                       = "statistics-analizer-funcs"
  location                   = azurerm_resource_group.project_group_computing.location
  resource_group_name        = azurerm_resource_group.project_group_computing.name
  app_service_plan_id        = azurerm_app_service_plan.project_funcs_service_plan.id
  storage_account_name       = var.project_storage_acc_name
  storage_account_access_key = var.project_storage_acc_primary_access_key
  version = "~3"

  site_config {
      always_on = true
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.funcs_app_insights.instrumentation_key}"
    "EventHubConnectionString" = "${var.event_hub_connection_string}",
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
  location            = azurerm_resource_group.project_group_computing.location
  resource_group_name = azurerm_resource_group.project_group_computing.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "statistics_aggregator_app_service" {
  name                = "statistics-aggregator-app-service"
  location            = azurerm_resource_group.project_group_computing.location
  resource_group_name = azurerm_resource_group.project_group_computing.name
  app_service_plan_id = azurerm_app_service_plan.web_app_service_plan.id

  connection_string {
    name  = "StatisticsDBConnectionString"
    type  = "SQLServer"
    value = var.db_connection_string
  }
}