# locals {
#   email_receiver_group = local.single_email

#   single_email = [
#     { name = "single", email_address = "single@test.nl", use_common_alert_schema = true }
#   ]
# }

# resource "azurerm_monitor_action_group" "action-group" {
#   name                = "action-group-rg-testcase"
#   resource_group_name = azurerm_resource_group.storage.name
#   short_name          = "shortername"

#   dynamic "arm_role_receiver" {
#     for_each = var.location_code == "weu" ? [] : [1]
#     content {
#       name                    = "AzureAdvisorAlerts${var.location_code}"
#       role_id                 = var.role-id-owner
#       use_common_alert_schema = true
#     }
#   }

#   dynamic "email_receiver" {
#     for_each = local.email_receiver_group
#     content {
#       name                    = email_receiver.value.name
#       email_address           = email_receiver.value.email_address
#       use_common_alert_schema = true
#     }
#   }
# }

# resource "azurerm_monitor_metric_alert" "storage_availability" {
#   name                = "alert-${var.storage_account_name}-storageavailability"
#   resource_group_name = azurerm_resource_group.storage.name
#   scopes              = [azurerm_storage_account.storage_account.id]
#   description         = "Action will be triggered Whenever the maximum availability storage is less than 70%"
#   window_size         = "PT30M"
#   frequency           = "PT15M"
#   severity            = 0

#   criteria {
#     metric_namespace = "Microsoft.Storage/storageAccounts"
#     metric_name      = "Availability"
#     aggregation      = "Maximum"
#     operator         = "LessThan"
#     threshold        = 70
#   }
# }

# resource "azurerm_monitor_scheduled_query_rules_alert" "resource_health" {
#   name                = "alert-${var.storage_account_name}-resourcehealth"
#   resource_group_name = azurerm_resource_group.storage.name
#   location            = azurerm_resource_group.storage.location
#   data_source_id      = azurerm_storage_account.storage_account.id
#   description         = "Resource health alert"
#   time_window         = 30
#   frequency           = 15
#   severity            = 0

#   query = <<-QUERY
#       AzureActivity
#           | where CategoryValue == 'ResourceHealth'
#           | where Level == 'Critical'
#       QUERY
#   trigger {
#     operator  = "GreaterThanOrEqual"
#     threshold = 1
#   }

#   dynamic "action" {
#     for_each = var.action_group_present == true ? ["true"] : []
#     content {
#       action_group = [azurerm_monitor_action_group.action-group.id]
#       custom_webhook_payload = jsonencode({
#         application_service1  = "application_service1"
#         business_criticality1 = "business_criticality1"
#       })
#     }
#   }
# }