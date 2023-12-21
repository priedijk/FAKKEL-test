resource "azurerm_resource_group" "example" {
  name     = "firewall-policy-test"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "firewall-vnet-test"
  address_space       = ["10.220.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-test"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.220.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "firewall-pip-test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Column (box) selection (Alt+Shift + Drag mouse)
resource "azurerm_public_ip" "example" {
  name                = "firewall-pip-test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
