locals {
    vnet_env      = "${var.location}_${var.tenant}"
}
/*
resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.weu.address_space]
}
*/
resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.local.vnet_env.address_space]
}
  
/*
resource "azurerm_virtual_network" "import-vnet1" {
  name                = "import-vnet1"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.weu.value.address_space]
}

resource "azurerm_virtual_network" "import-vnet2" {
  name                = "import-vnet2"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.value.weu.address_space]
}
*/
resource "azurerm_subnet" "subnets" {
  for_each             = var.network
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [each.value.subnet_address]
}
