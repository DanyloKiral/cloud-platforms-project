output "db_connection_string" {
  value     = "Server=tcp:${azurerm_mssql_server.statistics_db_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.statistics_db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.statistics_db_server.administrator_login};Password=${azurerm_mssql_server.statistics_db_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive = true
}

output "acc_store_connection_string" {
  value = "${azurerm_storage_account.project_storage_acc.primary_connection_string}"
  sensitive = true
}

output "event_hub_connection_string" {
  value = "${azurerm_eventhub_namespace.project_event_hub_ns.default_primary_connection_string}"
  sensitive = true
}

output "project_storage_acc_name" {
  value = "${azurerm_storage_account.project_storage_acc.name}"
}

output "project_storage_acc_primary_access_key" {
  value = "${azurerm_storage_account.project_storage_acc.primary_access_key}"
  sensitive = true
}