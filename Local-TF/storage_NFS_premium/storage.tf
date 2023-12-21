data "azurerm_client_config" "current" {}


resource "random_id" "storage" {
  byte_length = 4
}

resource "azurerm_resource_group" "storage" {
  name = "rg-storage"
  # name     = "rg-storage-policy"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                      = "stnfs${random_id.storage.hex}"
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_tier              = "Premium"
  account_kind              = "FileStorage"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Allow"
  }

  lifecycle {
    ignore_changes = [share_properties.0.smb]
  }
}

resource "azurerm_storage_share" "nfs" {
  name                 = "nfs"
  storage_account_name = azurerm_storage_account.storage_account.name
  access_tier          = "Premium"
  enabled_protocol     = "NFS"
  quota                = 200
}

# resource "azurerm_storage_share" "smb" {
#   name                 = "smb"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   access_tier          = "Premium"
#   enabled_protocol     = "SMB"
#   quota                = 200
# }
