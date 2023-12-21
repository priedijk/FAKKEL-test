resource "azurerm_resource_group" "correct" {
  name     = "rg-st-correct-endpoint"
  location = "West Europe"
}

resource "azurerm_resource_group" "wrong" {
  name     = "rg-st-wrong-endpoint"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "stendpointcc13408"
  resource_group_name      = azurerm_resource_group.correct.name
  location                 = azurerm_resource_group.correct.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "example" {
  name                = "virtnetname"
  address_space       = ["10.120.0.0/16"]
  location            = azurerm_resource_group.correct.location
  resource_group_name = azurerm_resource_group.correct.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnetname"
  resource_group_name  = azurerm_resource_group.correct.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.120.2.0/24"]
}

resource "azurerm_private_endpoint" "example" {
  name                = "st-example-endpoint"
  location            = azurerm_resource_group.correct.location
  resource_group_name = azurerm_resource_group.correct.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "sttest-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.correct.name
}


data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "storage_rbac" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.example.id
  principal_id         = data.azurerm_client_config.current.object_id
}



resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "diag_steex"
  target_resource_id = azurerm_storage_account.example.id
  storage_account_id = "/subscriptions/6d67d5d0-fc45-49eb-af8d-053a6064db99/resourceGroups/tfstatetestfakkel/providers/Microsoft.Storage/storageAccounts/tfstatetestfakkel"

  metric {
    category = "Capacity"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
