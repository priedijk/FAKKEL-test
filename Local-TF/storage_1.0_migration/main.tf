# Create customer managed key
resource "azurerm_key_vault_key" "cmk" {
  count        = var.secret_data ? 1 : 0
  name         = join("-", [var.storage_account_name, "cmk"])
  key_vault_id = data.azurerm_key_vault.keyvault.id
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
  lifecycle {
    ignore_changes = [
      expiration_date,
      not_before_date
    ]
  }

}

resource "azurerm_key_vault_access_policy" "storageaccount_identity_access_policy" {
  count        = var.secret_data ? 1 : 0
  key_vault_id = data.azurerm_key_vault.keyvault.id
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
  scope                = data.azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.storage_account.identity.0.principal_id
}

resource "azurerm_storage_account" "storage_account" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = data.azurerm_resource_group.resource_group.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  allow_blob_public_access  = var.allow_blob_public_access
  tags                      = local.tags

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
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_account_customer_managed_key" "cmk" {
  count              = var.secret_data ? 1 : 0
  key_vault_id       = data.azurerm_key_vault.keyvault.id
  storage_account_id = azurerm_storage_account.storage_account.id
  key_name           = azurerm_key_vault_key.cmk.0.name
  depends_on = [
    azurerm_key_vault_access_policy.storageaccount_identity_access_policy
  ]
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.storage_account_name}-pe"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet.id
  tags                = local.tags

  private_service_connection {
    name                           = "${var.storage_account_name}-pv-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "${var.storage_account_name}-blob-zone-grp"
    private_dns_zone_ids = [element(var.private_dns_zone_ids, 0)]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault_secret" "primary_access_key" {
  name         = join("-", [var.storage_account_name, "primary-access-key"])
  value        = sensitive(azurerm_storage_account.storage_account.primary_access_key)
  key_vault_id = data.azurerm_key_vault.keyvault.id
  content_type = "text/plain"
}
