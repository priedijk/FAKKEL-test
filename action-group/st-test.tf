# resource "azurerm_storage_account" "test" {
#   count                           = var.location_code == "weu" ? 1 : 0
#   name                            = "stttstest028318"
#   resource_group_name             = azurerm_resource_group.action-group-rg.name
#   location                        = "westeurope"
#   account_tier                    = "Standard"
#   account_replication_type        = "GRS"
#   allow_nested_items_to_be_public = false
#   enable_https_traffic_only       = true
#   min_tls_version                 = "TLS1_2"
# }

# resource "azurerm_storage_management_policy" "tfsecops_lcm" {
#   count              = var.location_code == "weu" && local.local1 == "peanut" ? 1 : 0
#   storage_account_id = azurerm_storage_account.test[0].id
#   rule {
#     name    = "Delete versions older than 30 days"
#     enabled = true
#     filters {
#       blob_types = ["blockBlob"]
#     }
#     actions {
#       version {
#         delete_after_days_since_creation = 30
#       }
#     }
#   }
# }
