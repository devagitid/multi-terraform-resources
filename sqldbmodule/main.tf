variable "resource_env" {
default = "default"
}

variable "admin_user" {
default = "default"
}

variable "admin_password" {
default = "default"
}

resource "azurerm_resource_group" "sqldb" {
  name     = "${var.resource_env}-rg"
  location = "eastus"
}

resource "azurerm_sql_server" "sqldb" {
  name                         = "mssqldbserver-${var.resource_env}"
  resource_group_name          = azurerm_resource_group.sqldb.name
  location                     = azurerm_resource_group.sqldb.location
  version                      = "12.0"
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password

  tags = {
    environment = var.resource_env
  }
}

resource "azurerm_storage_account" "sqldb" {
  name                     = "${var.resource_env}saacc01"
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



  tags = {
    environment = var.resource_env
  }
  
}
 output "administrator_login" {
   value = azurerm_sql_server.sqldb.administrator_login
}
 
 output "administrator_login_password" {
   value = azurerm_sql_server.sqldb.administrator_login_password
 }
