resource "azurerm_resource_group" "spoke" {
  name     = "rg-spoke${random_id.nr.hex}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke${random_id.nr.hex}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke-acrdns" {
  name                  = "spoke-acrdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubacr.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke-aksdns" {
  name                  = "spoke-aksdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubaks.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke-akvdns" {
  name                  = "spoke-akvdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubakv.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke-appsvcdns" {
  name                  = "spoke-appsvcdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubappsvc.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_subnet" "agw" {
  name                 = "agw-subnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.0.0/24"]
}

# test

# resource "azurerm_subnet_route_table_association" "agw" {
#   subnet_id      = azurerm_subnet.agw.id
#   route_table_id = azurerm_route_table.main.id
# }

resource "azurerm_subnet" "spoke" {
  name                                           = "spoke-subnet"
  resource_group_name                            = azurerm_resource_group.spoke.name
  virtual_network_name                           = azurerm_virtual_network.spoke.name
  address_prefixes                               = ["10.1.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet_route_table_association" "spoke" {
  subnet_id      = azurerm_subnet.spoke.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "data" {
  name                                           = "data-subnet"
  resource_group_name                            = azurerm_resource_group.spoke.name
  virtual_network_name                           = azurerm_virtual_network.spoke.name
  address_prefixes                               = ["10.1.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = false
}

resource "azurerm_subnet_route_table_association" "data" {
  subnet_id      = azurerm_subnet.data.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "spoke1int" {
  name                 = "spoke1int-subnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.3.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_route_table_association" "spoke1int" {
  subnet_id      = azurerm_subnet.spoke1int.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "spoke1int-2" {
  name                 = "spoke1int-2-subnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.13.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_route_table_association" "spoke1int-2" {
  subnet_id      = azurerm_subnet.spoke1int-2.id
  route_table_id = azurerm_route_table.main.id
}


resource "azurerm_subnet" "spoke1end" {
  name                                           = "spoke1end-subnet"
  resource_group_name                            = azurerm_resource_group.spoke.name
  virtual_network_name                           = azurerm_virtual_network.spoke.name
  address_prefixes                               = ["10.1.4.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_route_table_association" "spoke1end" {
  subnet_id      = azurerm_subnet.spoke1end.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_virtual_network_peering" "spoke2hub" {
  name                      = "spoke2hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}
