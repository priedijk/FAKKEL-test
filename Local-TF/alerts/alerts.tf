resource "azurerm_monitor_metric_alert" "example" {
  name                = "test-rule"
  resource_group_name = "eventhub"
  # resource_group_name = data.azurerm_resource_group.shared_hub.name
  scopes      = [azurerm_eventhub_namespace.eventhub.id]
  description = "Health probe to check for liveness"
  # scopes              = ["/subscriptions/6d67d5d0-fc45-49eb-af8d-053a6064db99/resourceGroups/eventhub/providers/Microsoft.EventHub/namespaces/taggingeventhubtest"]

  criteria {
    metric_namespace = "Microsoft.EventHub/namespaces"
    metric_name      = "IncomingMessages"
    aggregation      = "Average"
    operator         = "LessThanOrEqual"
    threshold        = 0
  }
  action {
    action_group_id    = azurerm_monitor_action_group.advisor.id
    webhook_properties = {}
    # action_group_id    = "/subscriptions/6D67D5D0-FC45-49EB-AF8D-053A6064DB99/resourceGroups/eventhub/providers/microsoft.insights/actionGroups/test-action-group"
  }
}
