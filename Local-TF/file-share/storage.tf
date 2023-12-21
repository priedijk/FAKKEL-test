resource "azurerm_storage_account" "example" {
  name                     = "fileshare1mystcaoocn"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_share" "example" {
  name                 = "myfileshare"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
}
