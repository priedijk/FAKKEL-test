resource "azurerm_resource_group" "branch-group-rg" {
  name     = "branch-test"
  location = var.resource_group_location
}
