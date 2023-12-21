resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.location_code}"
  location = var.resource_group_location
  tags = {
    "tag1"                    = "name2"
    "tag2_longerthanexpected" = "name2"
  }
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                       = "red-alert-${var.location_code}-001"
  location                   = azurerm_resource_group.vnet-rg.location
  resource_group_name        = azurerm_resource_group.vnet-rg.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway_virtual.id
  local_network_gateway_id   = azurerm_local_network_gateway.gateway_local.id
  dpd_timeout_seconds        = local.ipsec_policy.dpd_timeout_seconds
  shared_key                 = var.shared_key
  type                       = "IPsec"
}
