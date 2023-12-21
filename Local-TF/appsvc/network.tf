locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-appserviceplanintegration"
  location = local.location
  tags = {
    "Name"    = "myapp-2"
    "version" = "2.10.0"
  }
  lifecycle {
    ignore_changes = [
      tags["version"]
    ]
  }
}

resource "azurerm_virtual_network" "appsvc" {
  name                = "appsvc"
  address_space       = ["10.150.0.0/24"]
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "endpoint" {
  name                 = "endpoint_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.150.0.0/25"]
}

resource "azurerm_subnet" "delegated" {
  name                 = "delegation_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.appsvc.name
  address_prefixes     = ["10.150.0.224/27"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
}
