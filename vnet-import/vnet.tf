locals {
  peanut = var.location == "frc" ? "yes" : "no"
}

resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = ["10.20.0.0/16"]

  tags = {
    tag1 = "value1",
    tag2 = "value2"
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  name                 = each.value.name
  resource_group_name  = each.key
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = each.value.address_prefix
}

/*
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.0/27"]
}
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.32/27"]
}
*/