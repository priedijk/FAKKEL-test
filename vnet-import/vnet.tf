/*
locals {
  subnets_flatlist = flatten([for key, val in var.network : [
    for subnet in val.subnets : {
      vnet_name      = key
      subnet_name    = subnet.subnet_name
      subnet_address = subnet.subnet_address
    }
    ]
  ])

  subnets = { for subnet in local.subnets_flatlist : subnet.subnet_name => subnet }
}
*/

resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = ["10.20.0.0/16"]
}
/*
resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = ["10.20.0.0/16"]
}
*/
resource "azurerm_subnet" "subnets" {
  for_each             = var.network
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [each.value.subnet_address]
}

/*
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.0/27"]
}
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.32/27"]
}
*/