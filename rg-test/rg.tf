locals {
  chooser = var.location_code == "weu" ? var.choose_name_1 : var.choose_name_2
}

resource "random_pet" "rg-name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.chooser}"
  location = var.resource_group_location
}