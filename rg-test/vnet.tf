locals {
  dns1 = "10.20.0.1"
  dns2 = "10.20.0.4"

  dns_servers = [local.dns_server1, local.dns_server2]
  dns_server1 = replace(var.address_space.vnet, "0.0/24", "0.36")
  dns_server2 = replace(var.address_space.vnet, "0.0/24", "0.37")
}

resource "azurerm_virtual_network" "vnet" {
  name                = "rg-vnet-te"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.address_space2.vnet
  dns_servers         = local.dns_servers
}

resource "azurerm_subnet" "tb" {
  name                                          = "tbsubnet"
  resource_group_name                           = azurerm_resource_group.rg.name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = [replace(var.address_space.regional, "0.0/24", "0.176/28")]
  service_endpoints                             = var.location_code == "weu" && var.tenant == "ae" ? ["Microsoft.Storage"] : null
}