resource "azurerm_resource_group" "rg_actiongroup" {
  name     = "rg-actiongroup-${var.location_code}"
  location = var.location
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = action-group1
  resource_group_name = azurerm_resource_group.rg_actiongroup.name
  short_name          = "actiongroup1"

  event_hub_receiver {
    name                    = "test"
    event_hub_name          = data.azurerm_eventhub.eventhub.name
    event_hub_namespace     = data.azurerm_eventhub.eventhub.namespace_name
    use_common_alert_schema = true
  }
}
