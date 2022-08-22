locals {
  local_gateway_ip_address = lookup(var.address_space, "${var.location_code}_${var.tenant}").local_gateway_ip_address
  local_address_space      = lookup(var.address_space, "${var.location_code}_${var.tenant}").local_address_space

}

resource "azurerm_local_network_gateway" "gateway_local" {
  name                = "lgateway-${var.location_code}-001"
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
  gateway_address     = local.local_gateway_ip_address
  address_space       = local.local_address_space
}