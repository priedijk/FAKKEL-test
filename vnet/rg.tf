resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.resource_group_location
}