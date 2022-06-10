resource "azurerm_resource_group" "aa-rg" {
  name     = "aa-rg-resources"
  location = "West Europe"
}

resource "azurerm_automation_account" "aa-rg" {
  name                          = "aa-rg-account"
  location                      = azurerm_resource_group.aa-rg.location
  resource_group_name           = azurerm_resource_group.aa-rg.name
  sku_name                      = "Basic"
  public_network_access_enabled = false

  tags = {
    environment = "quick"
  }
}