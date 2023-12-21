locals {
  vnet_address_space = lookup(var.address_space, "${var.location_code}_${var.tenant}").address_space

  subnets     = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  subnets_weu = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae
  subnets_frc = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae

}

resource "azurerm_resource_group" "agw-rg" {
  name     = "agw-test"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "agw-tests" {
  name                = "agw-tests"
  resource_group_name = azurerm_resource_group.agw-rg.name
  location            = azurerm_resource_group.agw-rg.location
  address_space       = [local.vnet_address_space]
  dns_servers         = ["10.20.0.1", "10.20.0.4"]
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  name                 = each.key
  resource_group_name  = azurerm_resource_group.agw-rg.name
  virtual_network_name = azurerm_virtual_network.agw-tests.name
  address_prefixes     = [each.value.subnet_address]
  service_endpoints    = each.value.service_endpoint

  dynamic "delegation" {
    for_each = each.value.service_delegation == null ? [] : [1]

    content {
      name = "delegation"

      service_delegation {
        name = each.value.service_delegation
      }
    }
  }
}
