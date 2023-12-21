resource "azurerm_monitor_data_collection_rule" "linux" {
  name                = "dcr_linux"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name
  kind                = "Linux"
  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.vm_ama.id
      name                  = "log-analytics"
    }
  }
  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["log-analytics"]
  }
  data_sources {
    syslog {
      facility_names = ["auth", "authpriv", "daemon", "syslog"]
      log_levels     = ["Debug", "Info", "Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }
    performance_counter {
      counter_specifiers            = ["Logical Disk(*)\\% Free Space"]
      name                          = "perfCounterDataSource60"
      sampling_frequency_in_seconds = 60
      streams                       = ["Microsoft-Perf"]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "linux" {
  name                    = "vm-ama-linux-test"
  target_resource_id      = azurerm_linux_virtual_machine.linux.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.linux.id
}
