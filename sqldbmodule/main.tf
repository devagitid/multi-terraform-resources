variable "resource_env" {

default = "default"

}

resource "azurerm_resource_group" "sqldb" {
  name     = "${var.resource_env}-rg"
  location = "eastus"
}

resource "azurerm_sql_server" "sqldb" {
  name                         = "sqlserver-${var.resource_env}"
  resource_group_name          = azurerm_resource_group.sqldb.name
  location                     = azurerm_resource_group.sqldb.location
  version                      = "12.0"
  administrator_login          = "admin-${var.resource_env}"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = {
    environment = var.resource_env
  }
}

resource "azurerm_storage_account" "sqldb" {
  name                     = "sa-${var.resource_env}"
  resource_group_name      = azurerm_resource_group.sqldb.name
  location                 = azurerm_resource_group.sqldb.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sqldb" {
  name                = "sqldatabase-${var.resource_env}"
  resource_group_name = azurerm_resource_group.sqldb.name
  location            = azurerm_resource_group.sqldb.location
  server_name         = azurerm_sql_server.sqldb.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sqldb.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sqldb.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }



  tags = {
    environment = var.resource_env
  }
}
