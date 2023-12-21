#Set Diagnostic settings to eventhub namespace
resource "azurerm_monitor_diagnostic_setting" "evhns" {
  name                           = "diag_evhns-${var.location_code}"
  target_resource_id             = azurerm_eventhub_namespace.eventhub.id
  eventhub_name                  = azurerm_eventhub.eventhub.name
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.managediag_test.id

  enabled_log {
    category = "ArchiveLogs"
  }
  enabled_log {
    category = "OperationalLogs"
  }
  enabled_log {
    category = "AutoScaleLogs"
  }
  enabled_log {
    category = "KafkaCoordinatorLogs"
  }
  enabled_log {
    category = "KafkaUserErrorLogs"
  }
  enabled_log {
    category = "CustomerManagedKeyUserLogs"
  }
  enabled_log {
    category = "RuntimeAuditLogs"
  }
  enabled_log {
    category = "ApplicationMetricsLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

# resource "azurerm_monitor_diagnostic_setting" "evhns2" {
#   name               = "diag_evhns2-${var.location_code}"
#   target_resource_id = azurerm_eventhub_namespace.eventhub.id
#   log_analytics_destination_type = "AzureDiagnostics"
#   eventhub_name                  = azurerm_eventhub.eventhub.name
#   eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.managediag.id

#   enabled_log {
#     category = "EventHubVNetConnectionEvent"
#   }
#   depends_on = [
#     azurerm_monitor_diagnostic_setting.evhns
#   ]
# }
