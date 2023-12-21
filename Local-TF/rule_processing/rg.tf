locals {
  
}

resource "azurerm_resource_group" "rg" {
  name     = "processing-alert"
  location = "West Europe"
}
