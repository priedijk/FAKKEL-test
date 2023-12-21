# Azure Monitor Extension
resource "azurerm_virtual_machine_extension" "azuremonitorlinuxagent" {
  count                      = local.ama_enabled == true ? 1 : 0
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.27"
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

# settings = jsonencode({
#   workspaceId               = azurerm_log_analytics_workspace.vm_ama.id
#   azureResourceId           = azurerm_linux_virtual_machine.disks.id
#   stopOnMultipleConnections = false

#   authentication = {
#     managedIdentity = {
#       identifier-name  = "mi_ama_test_id"
#       identifier-value = azurerm_user_assigned_identity.vm.id
#     }
#   }
# })
# protected_settings = jsonencode({
#   "workspaceKey" = azurerm_log_analytics_workspace.vm_ama.primary_shared_key
# })
# }

resource "azurerm_virtual_machine_extension" "oms_linux" {
  count                = local.mma_enabled == true ? 1 : 0
  name                 = "OmsAgentForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.14"
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
