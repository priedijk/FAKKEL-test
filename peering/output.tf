data "azurerm_virtual_network" "vnet1" {
  name                = azurerm_virtual_network.vnet1.name
  resource_group_name = azurerm_resource_group.rg.name
}

output "peering1" {
  value = data.azurerm_virtual_network.vnet1.vnet_peerings
}

output "peering2" {
  value = data.azurerm_virtual_network.vnet1.vnet_peerings_addresses
}
