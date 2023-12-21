locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-integration"
  location = local.location
}

resource "azurerm_virtual_network" "appsvc" {
  name                = "vnetintegration"
  address_space       = ["10.180.0.0/24"]
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "endpoint" {
  name                 = "endpoint_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.180.0.0/25"]
}

resource "azurerm_subnet" "delegated" {
  name                 = "delegation_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.180.0.128/27"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "delegated2" {
  name                 = "delegation2_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.180.0.160/27"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "delegated3" {
  name                 = "delegation3_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.180.0.192/27"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "delegated4" {
  name                 = "delegation4_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.180.0.224/27"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}
