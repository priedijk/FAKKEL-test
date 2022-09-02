locals {
  chooser       = var.location_code == "frc" ? local.choose_name_1 : local.choose_name_2
  choose_name_1 = "name1-chosen"
  choose_name_2 = "name2-chosen"
}

resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  count    = var.location_code == "frc" ? 0 : 1
  name     = "rg-${var.address_space.rg_name}"
  location = var.resource_group_location
}

data "azurerm_resource_group" "rg" {
  name       = "rg-${var.address_space.rg_name}"
  depends_on = [azurerm_resource_group.rg]
}
