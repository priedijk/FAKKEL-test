locals {
  vnet_address_space = lookup(var.vnet_address_space, "${var.location}_${var.tenant}").address_space
  subnets_weu        = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae
  subnets_frc        = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [local.vnet_address_space]
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [each.value.subnet_address]
}

resource "azurerm_subnet" "subnet-test" {
  name                 = "subnetname1"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [var.network_weu_ae.firewall.bastion]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.nsg
  name                = each.value
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
}

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

resource "azurerm_network_security_rule" "nsg_rules_bastion2" {
  name                        = "AllowBastionHostToHostOutBound"
  description                 = ""
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["8080","5701"]
  source_address_prefix       = local.vnet_address_space
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.nsg_bastion.name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = var.location == "weu" ? local.subnets_weu : local.subnets_frc
  subnet_id                 = azurerm_subnet.subnets[each.value].id
  network_security_group_id = azurerm_network_security_group[each.value.nsg].id
}

/*
resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = azurerm_subnet.subnets["gateway"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
*/

output "test" {
  value = local.subnets_weu
}
