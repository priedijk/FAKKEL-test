locals {
    vnet_address_space = "${lookup(var.vnet_address_space, "${var.location}_${var.tenant}").address_space}"
    subnets_weu    = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae 
    subnets_frc    = var.tenant == "ae" ? var.network_weu_ae : var.network_weu_ae 
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

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-Group1"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = azurerm_subnet.subnets.gateway
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  subnet_id                 = azurerm_subnet.subnets.firewall
  network_security_group_id = azurerm_network_security_group.nsg.id
}

output "test" {
  value = local.subnets_weu 
}
