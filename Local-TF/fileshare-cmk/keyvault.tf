data "azurerm_client_config" "current" {}


resource "random_id" "kvname" {
  byte_length = 4
}

resource "azurerm_resource_group" "disks" {
  name     = "rg-cmk-fshare"
  location = "West Europe"
}

resource "azurerm_key_vault" "disks" {
  name                        = "kv-cmk-st-${var.location_code}-${lower(random_id.kvname.hex)}"
  location                    = azurerm_resource_group.disks.location
  resource_group_name         = azurerm_resource_group.disks.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = false
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "premium"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create"
    ]

    secret_permissions = [
      "Get", "List", "Set"
    ]

    storage_permissions = [
      "Get", "List"
    ]
  }
}
