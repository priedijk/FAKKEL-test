resource "azurerm_resource_group" "vm_ama" {
  name     = "ama-vm-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vm_ama" {
  name                = "ama-vm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name
}

resource "azurerm_subnet" "vm_ama" {
  name                 = "ama-vm-internal"
  resource_group_name  = azurerm_resource_group.vm_ama.name
  virtual_network_name = azurerm_virtual_network.vm_ama.name
  address_prefixes     = ["10.0.4.0/24"]
}
