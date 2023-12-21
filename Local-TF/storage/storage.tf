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
  name                = "ststorage${random_id.storage.hex}"
  resource_group_name = azurerm_resource_group.storage.name
  location            = azurerm_resource_group.storage.location
  # account_kind              = var.account_kind
  # account_tier              = var.account_tier
  account_kind                     = var.account_kind
  account_tier                     = "Standard"
  account_replication_type         = var.account_replication_type
  enable_https_traffic_only        = true
  min_tls_version                  = var.min_tls_version
  public_network_access_enabled    = false
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Allow"
  }
}
