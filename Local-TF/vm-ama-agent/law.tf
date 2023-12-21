resource "azurerm_log_analytics_workspace" "vm_ama" {
  name                = "law-ama-vm"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name
  sku                 = "PerGB2018"
}
