data "azurerm_subscription" "current" {
}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "restart-activitylog-alert-via-terraform"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "This alert will monitor if a VM restarts in the subscription."

  criteria {
    operation_name = "Microsoft.Compute/virtualMachines/restart/action"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.test-group.id
  }
}
