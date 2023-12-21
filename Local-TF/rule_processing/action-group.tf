resource "azurerm_monitor_action_group" "action_group" {
  name                = "action-processinggroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "progroup"
}
