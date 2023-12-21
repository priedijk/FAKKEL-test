resource "azurerm_virtual_machine_extension" "azuremonitorwindowsagent" {
  count                      = local.ama_enabled == true ? 1 : 0
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.20"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  settings = jsonencode({
    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = azurerm_user_assigned_identity.vm.id
      }
    }
  })
}



resource "azurerm_virtual_machine_extension" "oms_windows" {
  count                = local.mma_enabled == true ? 1 : 0
  name                 = "MicrosoftMonitoringAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  #auto_upgrade_minor_version = true

  settings           = <<SETTINGS
    {
        "workspaceId": "${azurerm_log_analytics_workspace.vm_ama.workspace_id}"
    }
SETTINGS
  protected_settings = <<PROTECTEDSETTINGS
    {
        "workspaceKey": "${azurerm_log_analytics_workspace.vm_ama.primary_shared_key}"
    }
PROTECTEDSETTINGS
}
