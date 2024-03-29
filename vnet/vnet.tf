locals {
  vnet_address_space = lookup(var.address_space, "${var.location_code}_${var.tenant}").address_space

  subnets     = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  subnets_weu = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae
  subnets_frc = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae

  vnet_space = lookup(var.address_space, "${var.location_code}_${var.tenant}")

  nsgs = {
    weballow     = "nsg_web_${var.location_code}"
    apim         = "nsg_ap_${var.location_code}"
    apim_ingress = "nsg_api_${var.location_code}"
  }
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [local.vnet_space.address_space]
  dns_servers         = ["10.20.0.1", "10.20.0.4"]
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  name                 = each.key
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
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

resource "azurerm_network_security_group" "nsg" {
  for_each            = local.nsgs
  name                = each.value
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
}

/*
resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-bastion"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
}

resource "azurerm_network_security_rule" "nsg_rules_bastion" {
  for_each                    = var.nsg_rules_bastion
  name                        = each.value.name
  description                 = each.value.description
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.nsg_bastion.name
}
*/
resource "azurerm_network_security_rule" "nsg_rules_bastion2" {
  name                        = "portranges"
  description                 = ""
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = local.vnet_address_space
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.nsg["weballow"].name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  #for_each                  = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  for_each                  = { for k, v in local.subnets_weu : k => v if lookup(v, "nsg", "") != null }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg].id
}

/*
resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = azurerm_subnet.subnets["gateway"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
*/

output "test" {
  value = local.vnet_space.regional_space
}
output "test2" {
  value = var.outputtest
}
