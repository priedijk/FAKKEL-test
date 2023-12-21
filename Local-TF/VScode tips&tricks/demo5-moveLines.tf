resource "azurerm_resource_group" "example" {
  name     = "firewall-policy-test"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "firewall-vnet-test"
  address_space       = ["10.220.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

