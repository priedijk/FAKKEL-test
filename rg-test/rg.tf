locals {
  chooser = var.location_code == "frc" ? local.choose_name_1 : local.choose_name_2
  choose_name_1 = "name1-chosen"
  choose_name_2 = "name2-chosen"
  dns1 = "10.20.0.1"
  dns2 = "10.20.0.4"
}

resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.address_space.rg_name}"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "rg-vnet-te"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.addres_space2
  dns_servers         = [local.dns1, local.dns2]
}