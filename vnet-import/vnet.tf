resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.network
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [each.value.subnet_address]
}
