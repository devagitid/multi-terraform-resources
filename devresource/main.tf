terraform {
backend "azure" {}
}

module "sqldbresource" {
source = "../sqldbmodule/"
resource_env = "dev"
admin_user     = "devadminuser"
admin_password = "123word@pass#$%^"
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
      key_permissions               = ["Get", "List"]
      secret_permissions            = ["Get", "List"]
      certificate_permissions       = ["Get", "Import", "List"]
      storage_permissions           = ["Backup", "Get", "List", "Recover"]
    
  }
  
 
}

resource "azurerm_key_vault_secret" "kv" {
  name         = "devadminuser" 
  value        = "password123"
  key_vault_id = azurerm_key_vault.kv.id
  
  depends_on = [
    module.sqldbresource
  ]
}
