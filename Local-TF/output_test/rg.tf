variable "prefix" {
  default = "output-automation"
}

locals {
  rg_name = "${var.prefix}-vm"
  length  = []
}

resource "azurerm_resource_group" "output" {
  count    = length(local.length) > 0 ? 1 : 0
  name     = "${var.prefix}-resources"
  location = var.resource_group_location
}

output "endpoint" {
  value = length(local.length) > 0 ? azurerm_resource_group.output[0].id : null
}
