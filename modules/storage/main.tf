resource "azurerm_resource_group" "project_group_storage" {
  name     = "cpProjectGroup_Storage"
  location = "westus2"
}

resource "azurerm_storage_account" "project_storage_acc" {
  name                     = "projectdatastore"
  resource_group_name      = azurerm_resource_group.project_group_storage.name
  location                 = azurerm_resource_group.project_group_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "reddit_comments_container" {
  name                  = "reddit-comments-archive"
  storage_account_name  = azurerm_storage_account.project_storage_acc.name
  container_access_type = "private"
}

resource "azurerm_mssql_server" "statistics_db_server" {
  name                         = "statistics-sqlserver"
  resource_group_name          = azurerm_resource_group.project_group_storage.name
  location                     = azurerm_resource_group.project_group_storage.location
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
  name                = "cpprojecteventhubns"
  location            = azurerm_resource_group.project_group_storage.location
  resource_group_name = azurerm_resource_group.project_group_storage.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "reddit_messages_event_hub" {
  name                = "redditMessagesTopic"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  resource_group_name = azurerm_resource_group.project_group_storage.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "language_detector_group" {
  name                = "language-detector-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group_storage.name
}

resource "azurerm_eventhub_consumer_group" "sentiment_analyzer_group" {
  name                = "sentiment-analyzer-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group_storage.name
}

resource "azurerm_eventhub_consumer_group" "keywords_extractor_group" {
  name                = "keywords-extractor-consumer"
  namespace_name      = azurerm_eventhub_namespace.project_event_hub_ns.name
  eventhub_name       = azurerm_eventhub.reddit_messages_event_hub.name
  resource_group_name = azurerm_resource_group.project_group_storage.name
}