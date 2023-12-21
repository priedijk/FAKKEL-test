variable "prefix" {
  default = "test-automation"
}

locals {
  rg_name = "${var.prefix}-vm"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = var.resource_group_location
}

