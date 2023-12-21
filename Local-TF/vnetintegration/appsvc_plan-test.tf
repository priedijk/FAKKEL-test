resource "azurerm_app_service_plan" "terraform" {
  name                = var.app_service_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = local.tags
}

data "azurerm_subscription" "current" {
}

variable "number_tag" {
  type    = string
  default = "1"
}

variable "application_tag" {
  type    = string
  default = "noapp"
}
variable "inherited_tags" {
  type    = list(any)
  default = ["owner", "cloudscope", "environment", "businessunit", "tenant"]
}
locals {
  filteredtags = { for k in var.inherited_tags : k => lookup(data.azurerm_subscription.current.tags, k, "undefined") }
  tags = merge(local.filteredtags, tomap(
    {
      "application"      = var.application_tag,
      "app_service_plan" = 1
  }))
}
