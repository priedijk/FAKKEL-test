locals {
  ipsec_policy = lookup(var.ipsec_policy, "${var.location}_${var.tenant}")
}


resource "azurerm_virtual_network_gateway_connection" "connection_vpn" {
  name                       = "ared-connection-${var.location}-001"
  location                   = azurerm_resource_group.vnet-rg.location
  resource_group_name        = azurerm_resource_group.vnet-rg.name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway_virtual.id
  local_network_gateway_id   = azurerm_local_network_gateway.gateway_local.id
  dpd_timeout_seconds        = local.ipsec_policy.dpd_timeout_seconds
  shared_key                 = var.shared_key
  type                       = "IPsec"

  ipsec_policy {
    dhGroup             = local.ipsec_policy.dhGroup
    ikeEncryption       = local.ipsec_policy.ikeEncryption
    ikeIntegrity        = local.ipsec_policy.ikeIntegrity
    ipsecEncryption     = local.ipsec_policy.ipsecEncryption
    ipsecIntegrity      = local.ipsec_policy.ipsecIntegrity
    pfsGroup            = local.ipsec_policy.pfsGroup
    saDataSizeKilobytes = local.ipsec_policy.saDataSizeKilobytes
    saLifeTimeSeconds   = local.ipsec_policy.saLifeTimeSeconds
  }

  tags = var.tags
}