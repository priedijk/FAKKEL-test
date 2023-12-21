data "azurerm_subscription" "current" {
}

resource "azurerm_monitor_alert_processing_rule_action_group" "example" {
  name                 = "backupprocessingrule"
  resource_group_name  = azurerm_resource_group.rg.name
  scopes               = [data.azurerm_subscription.current.id]
  add_action_group_ids = [azurerm_monitor_action_group.action_group.id]
  description          = "This is a test backup/restore failure alert"

  condition {
    target_resource_type {
      operator = "Equals"
      values   = ["Microsoft.RecoveryServices/vaults"]
    }
    severity {
      operator = "Equals"
      values   = ["Sev0", "Sev1", "Sev2"]
    }
  }
}
