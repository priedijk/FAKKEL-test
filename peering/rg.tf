resource "azurerm_resource_group" "rg" {

  name     = "rg-${var.location_code}"
  location = var.resource_group_location
}
