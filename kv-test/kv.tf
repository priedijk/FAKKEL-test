data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "fakkel" {
  name     = "fakkel-kv"
  location = "West Europe"
}

resource "azurerm_key_vault" "fakkel" {
  name                        = "fakkelkeyvault"
  location                    = azurerm_resource_group.fakkel.location
  resource_group_name         = azurerm_resource_group.fakkel.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  
  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "622c186c-008a-457c-be8b-d0f91f62e393"

    key_permissions = [
      "Get"
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}