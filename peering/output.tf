data "azurerm_virtual_network" "vnet1" {
  name                = azurerm_virtual_network.vnet1.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_resource_group" "output" {
  name     = "output-tester"
  location = "westeurope"
  tags = {
    key1 = data.azurerm_virtual_network.vnet1.vnet_peerings[0]
    key2 = data.azurerm_virtual_network.vnet1.vnet_peerings.id
  }
}

output "peering1" {
  value = data.azurerm_virtual_network.vnet1.vnet_peerings
}
output "peering1-1" {
  value = data.azurerm_virtual_network.vnet1.vnet_peerings.id
}

# output "peering1-2" {
#   value = data.azurerm_virtual_network.vnet1.vnet_peerings[each.key]
# }

output "peering2" {
  value = data.azurerm_virtual_network.vnet1.vnet_peerings_addresses
}
# output "peering2-1" {
#   value = data.azurerm_virtual_network.vnet1.vnet_peerings_addresses.id
# }
# output "peering2-2" {
#   value = data.azurerm_virtual_network.vnet1.vnet_peerings_addresses[each.key]
# }
