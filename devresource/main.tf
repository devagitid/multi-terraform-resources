terraform {
backend "azure" {}
}

module "sqldbresource" {
source = "../sqldbmodule/"
resource_env = "dev"
}

data "azurerm_client_config" "current" {}
  
resource "azurerm_key_vault" "kv" {
  name                       = "keyvault01"
  location                   = "eastus"
  resource_group_name        = "dev-rg"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7
    
  depends_on = [
    module.sqldbresource
  ]

  access_policy {
   
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id
      key_permissions               = ["get", "list"]
      secret_permissions            = ["get", "list"]
      certificate_permissions       = ["get", "import", "list"]
      storage_permissions           = ["backup", "get", "list", "recover"]
    
  }
  
 
}

resource "azurerm_key_vault_secret" "kv" {
  name         = module.sqldbresource.azurerm_sql_server.sqldb.administrator_login
  value        = module.sqldbresource.azurerm_sql_server.sqldb.administrator_login_password
  key_vault_id = azurerm_key_vault.kv.id
  
  depends_on = [
    module.sqldbresource
  ]
}
