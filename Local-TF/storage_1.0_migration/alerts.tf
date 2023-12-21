resource "azurerm_monitor_metric_alert" "storage_availability" {
  name                = "alert-${var.storage_account_name}-storageavailability"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_storage_account.storage_account.id]
  description         = "Action will be triggered Whenever the maximum availability storage is less than 70%"
  window_size         = "PT30M"
  frequency           = "PT15M"
  severity            = 0

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Availability"
    aggregation      = "Maximum"
    operator         = "LessThan"
    threshold        = 70
  }

  dynamic "action" {
    for_each = var.action_group_present == true ? ["true"] : []
    content {
      action_group_id = data.azurerm_monitor_action_group.action_group[0].id
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

#Resource Health Alert

resource "azurerm_monitor_scheduled_query_rules_alert" "resource_health" {
  name                = "alert-${var.storage_account_name}-resourcehealth"
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.resource_group.location
  data_source_id      = azurerm_storage_account.storage_account.id
  description         = "Resource health alert"
  time_window         = 30
  frequency           = 15
  severity            = 0

  query = <<-QUERY
      AzureActivity
          | where CategoryValue == 'ResourceHealth'
          | where Level == 'Critical'
      QUERY
  trigger {
    operator  = "GreaterThanOrEqual"
    threshold = 1
  }

  dynamic "action" {
    for_each = var.action_group_present == true ? ["true"] : []
    content {
      action_group = [data.azurerm_monitor_action_group.action_group[0].id]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}
