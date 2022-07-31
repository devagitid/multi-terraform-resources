terraform {
backend "azure" {}
}

module "sqldbresource" {
source = "../sqldbmodule/"
resource_env = "dev"
}

data "azurerm_resource_group" "sqldb" {
}
  
data "azurerm_sql_server" "sqldb" {
}
  
resource "azurerm_key_vault" "kv" {
  name                       = "keyvault01"
  location                   = module.sqldbresource.azurerm_sql_server.sqldb.location
  resource_group_name        = module.sqldbresource.azurerm_sql_server.sqldb.name
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
   
      azure_ad_user_principal_names = ["devdattajadhav79gmail.onmicrosoft.com"]
      key_permissions               = ["get", "list"]
      secret_permissions            = ["get", "list"]
      certificate_permissions       = ["get", "import", "list"]
      storage_permissions           = ["backup", "get", "list", "recover"]
    
  }
}

resource "azurerm_key_vault_secret" "kv" {
  name         = data.azurerm_sql_server.sqldb.administrator_login
  value        = data.azurerm_sql_server.sqldb.administrator_login_password
  key_vault_id = azurerm_key_vault.kv.id
}
