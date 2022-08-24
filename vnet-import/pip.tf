variable "public_ip" {
  type = map(object({
    allocation_method = string
    availability_zone = string
    sku               = string
    })
  )
  default = {
    "bast" = {
      allocation_method = "Static"
      availability_zone = "Zone-Redundant"
      sku               = "Standard"
    },
    "gw" = {
      allocation_method = "Static"
      availability_zone = "No-Zone"
      sku               = "Standard"
    },
    "fw" = {
      allocation_method = "Static"
      availability_zone = "Zone-Redundant"
      sku               = "Standard"
    },
    "fw-mgmt" = {
      allocation_method = "Static"
      availability_zone = "Zone-Redundant"
      sku               = "Standard"
    }
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = var.public_ip
  name                = "pip-${each.key}-shared-hub-${var.location}-001"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  allocation_method   = each.value.allocation_method
  availability_zone   = each.value.availability_zone
  sku                 = each.value.sku
}