resource "azurerm_virtual_network" "aks" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.20.16.0/23"]
}

resource "azurerm_subnet" "systempool" {
  name                 = "systempool-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.20.17.32/27"]
}

resource "azurerm_subnet_route_table_association" "systempool" {
  subnet_id      = azurerm_subnet.systempool.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "userpool" {
  name                 = "userpool-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.20.17.64/27"]
}

resource "azurerm_subnet_route_table_association" "userpool" {
  subnet_id      = azurerm_subnet.userpool.id
  route_table_id = azurerm_route_table.main.id
}


resource "azurerm_subnet" "data" {
  name                 = "data-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.20.16.192/26"]
}

resource "azurerm_subnet_route_table_association" "data" {
  subnet_id      = azurerm_subnet.data.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "aks1end" {
  name                 = "aks1end-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.20.17.0/28"]
}

resource "azurerm_subnet_route_table_association" "aks1end" {
  subnet_id      = azurerm_subnet.aks1end.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_route_table" "main" {
  name                = "main"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  route {
    name           = "azure"
    address_prefix = "AzureCloud"
    next_hop_type  = "Internet"
  }

  route {
    name           = "mypip"
    address_prefix = "84.104.239.28/32"
    next_hop_type  = "Internet"
  }
  route {
    name           = "mypip-fakkel"
    address_prefix = "109.69.228.221/32"
    next_hop_type  = "Internet"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      route
    ]
  }
}
