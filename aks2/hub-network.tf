
resource "azurerm_resource_group" "hub" {
  name     = "rg-hub${random_id.nr.hex}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub${random_id.nr.hex}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]
}
