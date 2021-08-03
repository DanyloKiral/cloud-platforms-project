variable "db_connection_string" {
    sensitive = true
}
variable "acc_store_connection_string" {
    sensitive = true
}
variable "event_hub_connection_string" {
    sensitive = true
}
variable "project_storage_acc_name" {}
variable "project_storage_acc_primary_access_key" {
  sensitive = true
}
