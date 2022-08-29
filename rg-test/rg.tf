locals {
  chooser = var.location_code == "frc" ? local.choose_name_1 : local.choose_name_2
  choose_name_1 = "name1-chosen"
  choose_name_2 = "name2-chosen"
  dns1 = "10.20.0.1"
  dns2 = "10.20.0.4"

  dns_servers = [local.dns_server1, local.dns_server2]
  dns_server1 = replace(var.address_space.vnet, "0.0/24", "0.36")
  dns_server2 = replace(var.address_space.vnet, "0.0/24", "0.37")
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
  address_space       = var.address_space2.vnet
  dns_servers         = local.dns_servers
}