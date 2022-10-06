resource "azurerm_resource_group" "rg" {
  name     = "rg-output"
  location = var.resource_group_location
}
