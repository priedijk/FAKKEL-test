# # locals {
# #   evh_sku           = "Premium"
# #   evh_capacity      = "1"
# #   evh_count_nonprod = 1
# #   evh_count_prod    = 1
# # }

# resource "azurerm_eventhub_namespace" "shared" {
#   for_each            = var.eventhubs_shared
#   name                = "pskekkel-${each.key}-${var.location_code}-006"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = each.value.sku
#   # auto_inflate_enabled     = null
#   # maximum_throughput_units = null
#   # tags                = local.tags_eventhub_nonprod
#   capacity            = each.value.capacity
#   minimum_tls_version = "1.2"
#   network_rulesets = [
#     {
#       public_network_access_enabled = true
#       default_action                = "Deny"
#       virtual_network_rule          = []
#       ip_rule = [
#         {
#           action  = "Allow"
#           ip_mask = "10.0.0.0/8"
#         }
#       ]
#       trusted_service_access_enabled = true
#     }
#   ]
# }

# resource "azurerm_eventhub" "shared" {
#   for_each            = var.eventhubs_shared
#   name                = "evh-proulog-${each.key}-${var.location_code}-008"
#   namespace_name      = azurerm_eventhub_namespace.shared[each.key].name
#   resource_group_name = azurerm_resource_group.rg.name
#   partition_count     = each.value.partition_count
#   message_retention   = each.value.message_retention
# }
