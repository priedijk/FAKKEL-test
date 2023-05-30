data "azurerm_client_config" "current" {}

resource "random_id" "kvname" {
  byte_length = 4
}

data "azuread_service_principal" "local_spn" {
  display_name = "az_github_spn"
}

data "azuread_user" "patrick" {
  user_principal_name = "patrick.riedijk_avanade.com#EXT#@draaicloud.onmicrosoft.com"
}

resource "azurerm_resource_group" "fakkel" {
  name     = "fakkel-kv"
  location = "West Europe"
}

resource "azurerm_key_vault" "fakkel" {
  name                        = "kv-test-${var.location_code}-${lower(random_id.kvname.hex)}"
  location                    = azurerm_resource_group.fakkel.location
  resource_group_name         = azurerm_resource_group.fakkel.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = "premium"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  # access_policy {
  #   tenant_id = data.azurerm_client_config.current.tenant_id
  #   object_id = data.azurerm_client_config.current.object_id

  #   key_permissions = [
  #     "Get", "List"
  #   ]

  #   secret_permissions = [
  #     "Get", "List"
  #   ]

  #   storage_permissions = [
  #     "Get", "List"
  #   ]
  # }
}

# resource "azurerm_role_assignment" "spn_secret_getter" {
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = data.azuread_service_principal.local_spn.object_id
#   scope                = azurerm_key_vault.fakkel.id
# }

# resource "azurerm_role_assignment" "patrick_secret_getter" {
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = data.azuread_user.patrick.object_id
#   scope                = azurerm_key_vault.fakkel.id
# }
