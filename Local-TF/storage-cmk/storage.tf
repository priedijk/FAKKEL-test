

# Create customer managed key
resource "azurerm_key_vault_key" "cmk" {
  count        = var.secret_data ? 1 : 0
  name         = join("-", [var.storage_account_name, "cmk"])
  key_vault_id = azurerm_key_vault.disks.id
  key_type     = var.cmk_key_type
  key_size     = var.cmk_key_size

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "storageaccount_identity_access_policy" {
  count        = var.secret_data ? 1 : 0
  key_vault_id = azurerm_key_vault.disks.id
  tenant_id    = azurerm_storage_account.storage_account.identity[0].tenant_id
  object_id    = azurerm_storage_account.storage_account.identity[0].principal_id

  key_permissions = [
    "Get",
    "List",
    "UnwrapKey",
    "WrapKey"
  ]
}
resource "azurerm_role_assignment" "managed_identity_role" {
  count                = var.secret_data ? 1 : 0
  scope                = azurerm_key_vault.disks.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.storage_account.identity.0.principal_id
}

resource "azurerm_storage_account" "storage_account" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.disks.name
  location                  = azurerm_resource_group.disks.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny"
  }

  blob_properties {
    dynamic "delete_retention_policy" {
      for_each = var.is_blob_soft_delete_enabled == "yes" ? ["true"] : []
      content {
        days = var.blob_soft_delete_retention_days
      }
    }
    dynamic "container_delete_retention_policy" {
      for_each = var.is_container_soft_delete_enabled == "yes" ? ["true"] : []
      content {
        days = var.container_soft_delete_retention_days
      }
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
  }
  dynamic "identity" {
    for_each = (lower(var.secret_data) ? [1] : [])
    content {
      type = "SystemAssigned"
    }
  }
  lifecycle {
    ignore_changes = [customer_managed_key]
  }
}

resource "azurerm_storage_account_customer_managed_key" "cmk" {
  count              = var.secret_data ? 1 : 0
  key_vault_id       = azurerm_key_vault.disks.id
  storage_account_id = azurerm_storage_account.storage_account.id
  key_name           = azurerm_key_vault_key.cmk.0.name
  depends_on = [
    azurerm_key_vault_access_policy.storageaccount_identity_access_policy
  ]
}

resource "azurerm_key_vault_secret" "primary_access_key" {
  name         = join("-", [var.storage_account_name, "primary-access-key"])
  value        = sensitive(azurerm_storage_account.storage_account.primary_access_key)
  key_vault_id = azurerm_key_vault.disks.id
  content_type = "text/plain"
}
