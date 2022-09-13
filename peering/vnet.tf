locals {
  vnet_range1 = "10.20.0.0/24"
  vnet_range2 = "10.30.0.0/24"
  vnet_range3 = "10.40.0.0/24"
}

resource "azurerm_resource_group" "rg" {

  name     = "rg-${var.location_code}-peering"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "rg-vnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [local.vnet_range1]
}

resource "azurerm_subnet" "tb" {
  name                 = "tbsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [replace(local.vnet_range1, "0.0/24", "0.176/28")]
  service_endpoints    = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
}

resource "azurerm_subnet" "tb1" {
  name                 = "tb1subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [replace(local.vnet_range1, "0.0/24", "0.0/28")]
  service_endpoints    = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "rg-vnet2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [local.vnet_range2]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = [replace(local.vnet_range2, "0.0/24", "0.176/28")]
  service_endpoints    = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
}

resource "azurerm_virtual_network" "vnet3" {
  name                = "rg-vnet3"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [local.vnet_range3]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet3.name
  address_prefixes     = [replace(local.vnet_range3, "0.0/24", "0.176/28")]
  service_endpoints    = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
}
