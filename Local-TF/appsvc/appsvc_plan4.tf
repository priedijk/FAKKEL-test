# resource "azurerm_app_service_plan" "terraform4" {
#   name                = var.app_service_name4
#   location            = local.location
#   resource_group_name = azurerm_resource_group.rg.name

#   sku {
#     tier = "Standard"
#     size = "S1"
#   }
# }
