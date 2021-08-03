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

module "storage" {
  source = "./modules/storage"

  db_admin_username = var.db_admin_username
  db_admin_password = var.db_admin_password
}

module "computing" {
  source = "./modules/computing"

  db_connection_string = module.storage.db_connection_string
  acc_store_connection_string = module.storage.acc_store_connection_string
  event_hub_connection_string = module.storage.event_hub_connection_string
  project_storage_acc_name = module.storage.project_storage_acc_name
  project_storage_acc_primary_access_key = module.storage.project_storage_acc_primary_access_key
}
