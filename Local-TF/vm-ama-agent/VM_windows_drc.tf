resource "azurerm_monitor_data_collection_rule" "windows" {
  name                = "dcr_windows"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name
  kind                = "Windows"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.vm_ama.id
      name                  = "log-analytics"
    }
  }
  data_flow {
    streams      = ["Microsoft-Event", "Microsoft-Perf"]
    destinations = ["log-analytics"]
  }
  data_sources {
    windows_event_log {
      streams        = ["Microsoft-Event"]
      x_path_queries = ["Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4)]]", "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4)]]"]
      name           = "eventLogsDataSource"
    }
    performance_counter {
      counter_specifiers            = ["\\LogicalDisk(_Total)\\% Free Space"]
      name                          = "perfCounterDataSource60"
      sampling_frequency_in_seconds = 60
      streams                       = ["Microsoft-Perf"]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "windows" {
  name                    = "vm-ama-windows-test"
  target_resource_id      = azurerm_windows_virtual_machine.windows.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.windows.id
}
