data "azurerm_virtual_network" "vnet" {
  count               = var.new_deployment == true ? 0 : 1
  name                = "rg-${local.inverter}-peering"
  resource_group_name = "rg-${local.inverter}-peering"
}

resource "azurerm_virtual_network_peering" "peering" {
  count                     = var.new_deployment == true ? 0 : 1
  name                      = "perfrom-${var.location_code}-to-${local.inverter}"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet[0].id
}
