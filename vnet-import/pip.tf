variable "public_ip" {
  type = map(object({
    allocation_method  = string
    availability_zones = list(string)
    sku                = string
    })
  )
  default = {
    "bast" = {
      allocation_method  = "Static"
      availability_zones = ["1", "2", "3"]
      sku                = "Standard"
    },
    "gw" = {
      allocation_method  = "Static"
      availability_zones = null
      sku                = "Standard"
    },
    "fw" = {
      allocation_method  = "Static"
      availability_zones = ["1", "2", "3"]
      sku                = "Standard"
    },
    "fw-mgmt" = {
      allocation_method  = "Static"
      availability_zones = ["1", "2", "3"]
      sku                = "Standard"
    }
  }
}

/*
resource "azurerm_public_ip" "pip" {
  for_each            = var.public_ip
  name                = "pip-${each.key}-shared-hub-${var.location}-001"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  allocation_method   = each.value.allocation_method
  zones               = each.value.availability_zones
  sku                 = each.value.sku
}


resource "azurerm_management_lock" "public-ip" {
  for_each   = var.public_ip
  name       = "PiP_DoNotDelete"
  scope      = azurerm_public_ip.pip[each.key].id
  lock_level = "CanNotDelete"
  notes      = "Locked by the team."
}
*/