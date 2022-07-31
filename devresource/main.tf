terraform {
backend "azure" {}
}

module "sqldbresource" {
source = "../sqldbmodule/"
resource_env = "dev"
}

data "azurerm_sql_server" "sqldb" {
}
  
resource "azurerm_key_vault" "kv" {
  name                       = "keyvault01"
  location                   = azurerm_resource_group.sqldb.location
  resource_group_name        = azurerm_resource_group.sqldb.name
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
  name         = azurerm_sql_server.sqldb.administrator_login
  value        = azurerm_sql_server.sqldb.administrator_login_password
  key_vault_id = azurerm_key_vault.kv.id
}
