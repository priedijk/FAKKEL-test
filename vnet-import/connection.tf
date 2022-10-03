/*
locals {
  ipsec_policy = lookup(var.ipsec_policy, "${var.location_code}_${var.tenant}")
}


resource "azurerm_virtual_network_gateway_connection" "connection_vpn" {
  name                       = "ared-connection-${var.location_code}-001"
  location                   = azurerm_resource_group.vnet-rg.location
  resource_group_name        = azurerm_resource_group.vnet-rg.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway_virtual.id
  local_network_gateway_id   = azurerm_local_network_gateway.gateway_local.id
  dpd_timeout_seconds        = local.ipsec_policy.dpd_timeout_seconds
  shared_key                 = var.shared_key
  type                       = "IPsec"

  ipsec_policy {
    dh_group         = local.ipsec_policy.dh_group
    ike_encryption   = local.ipsec_policy.ike_encryption
    ike_integrity    = local.ipsec_policy.ike_integrity
    ipsec_encryption = local.ipsec_policy.ipsec_encryption
    ipsec_integrity  = local.ipsec_policy.ipsec_integrity
    pfs_group        = local.ipsec_policy.pfs_group
    sa_datasize      = local.ipsec_policy.sa_datasize
    sa_lifetime      = local.ipsec_policy.sa_lifetime
  }
}
*/
