resource "azurerm_log_analytics_datasource_windows_performance_counter" "windows" {
  name                = "example-lad-wpc"
  resource_group_name = azurerm_resource_group.example.name
  workspace_name      = azurerm_log_analytics_workspace.example.name
  object_name         = "LogicalDisk"
  instance_name       = "*"
  counter_name        = "% Free Space"
  interval_seconds    = 60
}
