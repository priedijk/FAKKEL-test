/*
locals {
  local_gateway_ip_address = lookup(var.address_space, "${var.location_code}_${var.tenant}").local_gateway_ip_address
  local_address_space      = lookup(var.address_space, "${var.location_code}_${var.tenant}").local_address_space
  vnet_space_local = lookup(var.address_space, "${var.location_code}_${var.tenant}")
}

resource "azurerm_local_network_gateway" "gateway_local" {
  name                = "lgateway-${var.location_code}-001"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  gateway_address     = local.local_gateway_ip_address
  address_space       = local.vnet_space_local.local_address_space
}
*/
