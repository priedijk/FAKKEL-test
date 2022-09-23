locals {
  vnet_range  = var.location_code == "weu" ? local.vnet_range1 : local.vnet_range2
  vnet_range1 = "10.20.0.0/24"
  vnet_range2 = "10.30.0.0/24"

}

# data "azurerm_virtual_network" "vnet_weu" {
#   count               = var.location_code == "frc" ? 1 : 0
#   name                = "rg-weu-peering"
#   resource_group_name = "rg-weu-peering"
# }
# data "azurerm_virtual_network" "vnet_frc" {
#   count               = var.location_code == "weu" ? 1 : 0
#   name                = "rg-frc-peering"
#   resource_group_name = "rg-frc-peering"
# }

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.location_code}-peering"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "rg-${var.location_code}-peering"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [local.vnet_range]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [replace(local.vnet_range, "0.0/24", "0.176/28")]
}

# resource "azurerm_virtual_network" "vnet_frc" {
#   name                = "rg-france"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = "francecentral"
#   address_space       = [local.vnet_range2]
# }

# resource "azurerm_subnet" "subnet2" {
#   name                 = "subnet2"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet2.name
#   address_prefixes     = [replace(local.vnet_range2, "0.0/24", "0.176/28")]
#   service_endpoints    = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
# }
