resource "random_id" "st" {
  byte_length = 4
}

resource "azurerm_resource_group" "azcopy" {
  location = "westeurope"
  name     = "fileshareazcopy"
}

resource "azurerm_storage_account" "storage_account" {
  name                      = "fileshareazcopy${lower(random_id.st.hex)}"
  resource_group_name       = azurerm_resource_group.azcopy.name
  location                  = azurerm_resource_group.azcopy.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Allow"
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
}

resource "azurerm_storage_share" "fileshares" {
  name                 = "dev"
  storage_account_name = azurerm_storage_account.storage_account.name
  access_tier          = var.access_tier
  enabled_protocol     = var.enabled_protocol
  quota                = var.quota
}
