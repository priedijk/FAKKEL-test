resource "azurerm_resource_group" "bastion" {
  name     = "bastion-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "bastion" {
  name                = "bastionvnet"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.bastion.name
  virtual_network_name = azurerm_virtual_network.bastion.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastionpip"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
  allocation_method   = "Static"
  sku                 = "standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastionbastion"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
  sku                 = "basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}