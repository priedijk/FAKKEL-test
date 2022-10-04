locals {
  private_dns_rg_name = "privatedns-test-001"
  vnet_data           = var.location_code == "frc" ? data.azurerm_virtual_network.frc : data.azurerm_virtual_network.weu
}

data "azurerm_virtual_network" "frc" {
  name                = "rg-frc-peering"
  resource_group_name = "rg-frc-peering"
}
data "azurerm_virtual_network" "weu" {
  name                = "rg-weu-peering"
  resource_group_name = "rg-weu-peering"
}

resource "azurerm_resource_group" "hub_private_dns" {
  count    = var.location_code == "frc" ? 0 : 1
  name     = "privatedns-test-001"
  location = var.location
}

resource "azurerm_private_dns_zone" "hub" {
  # count               = var.location_code == "frc" ? 0 : 1
  for_each            = var.location_code == "frc" ? toset(var.dns_zones) : []
  name                = each.value
  resource_group_name = local.private_dns_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each              = toset(var.dns_zones)
  name                  = "${each.value}-hub-vnet-${var.location_code}"
  resource_group_name   = local.private_dns_rg_name
  private_dns_zone_name = each.value
  virtual_network_id    = local.vnet_data.id
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
