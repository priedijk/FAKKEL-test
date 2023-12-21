locals {
  subnet_prefixes = {
    apim_prod_subnet         = ["10.20.0.64/27"]
    apim_ingress_prod_subnet = ["10.20.0.96/27"]
  }
  apim_prefixes = {
    akamai_staging    = local.ip_list
    akamai_gtm        = local.ip_list2
    akamai_siteshield = local.ip_list3
  }

  vnet_prefixes = {
    vnet_regional = lookup(var.address_space, "${var.location_code}_${var.tenant}").address_space
  }

  # for easy lookup in NSG's
  all_prefixes = merge(local.subnet_prefixes, local.vnet_prefixes, local.apim_prefixes)
}

resource "azurerm_network_security_group" "nsg_test" {
  name                = "nsg-bastion"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
}

resource "azurerm_network_security_rule" "nsg_rules_test" {
  for_each                     = merge(var.nsg_rules_default, var.nsg_rules_test)
  name                         = each.value.name
  description                  = each.value.description
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range
  destination_port_range       = each.value.destination_port_range
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = try(each.value.source_address_prefix, null)
  source_address_prefixes      = try(local.all_prefixes[replace(replace(each.value.source_address_prefixes, "local_subnet", "apim_ingress_prod_subnet"), "apim_subnet", "apim_prod_subnet")], null)
  destination_address_prefix   = try(each.value.destination_address_prefix, null)
  destination_address_prefixes = try(local.all_prefixes[replace(replace(each.value.destination_address_prefixes, "local_subnet", "apim_ingress_prod_subnet"), "apim_subnet", "apim_prod_subnet")], null)
  resource_group_name          = azurerm_resource_group.vnet-rg.name
  network_security_group_name  = azurerm_network_security_group.nsg_test.name
}

resource "azurerm_network_security_group" "nsg_test_dynamic" {
  name                = "nsg-test-dynamic"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location

  dynamic "security_rule" {
    for_each = merge(var.nsg_rules_default, var.nsg_rules_test)
    content {
      name                         = security_rule.value.name
      description                  = security_rule.value.description
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = try(security_rule.value.source_port_range, null)
      source_port_ranges           = try(security_rule.value.source_port_ranges, null)
      destination_port_range       = try(security_rule.value.destination_port_range, null)
      destination_port_ranges      = try(security_rule.value.destination_port_ranges, null)
      source_address_prefix        = try(security_rule.value.source_address_prefix, null)
      source_address_prefixes      = try(local.all_prefixes[replace(replace(security_rule.value.source_address_prefixes, "local_subnet", "apim_prod_subnet"), "apim_ingress_subnet", "apim_ingress_prod_subnet")], null)
      destination_address_prefix   = try(security_rule.value.destination_address_prefix, null)
      destination_address_prefixes = try(local.all_prefixes[replace(replace(security_rule.value.destination_address_prefixes, "local_subnet", "apim_prod_subnet"), "apim_ingress_subnet", "apim_ingress_prod_subnet")], null)
    }
  }
}

resource "azurerm_network_security_rule" "nsg_rules_test2" {
  name                   = "portranges"
  description            = ""
  priority               = 100
  direction              = "Outbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "65200-65535"
  # source_address_prefix       = local.vnet_address_space
  source_address_prefixes     = local.ip_list
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet-rg.name
  network_security_group_name = azurerm_network_security_group.nsg_test.name
}


