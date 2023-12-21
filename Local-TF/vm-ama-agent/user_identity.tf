resource "azurerm_user_assigned_identity" "vm" {
  resource_group_name = azurerm_resource_group.vm_ama.name
  location            = azurerm_resource_group.vm_ama.location
  name                = "id-vm-ama-test"
}
