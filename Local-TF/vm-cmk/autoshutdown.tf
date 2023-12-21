resource "azurerm_dev_test_global_vm_shutdown_schedule" "linux_vm" {
  count              = lookup(var.tags, "environment") == "nonprod" && var.vm_auto_shutdown_enabled == true ? 1 : 0
  virtual_machine_id = azurerm_virtual_machine.disks.id
  location           = azurerm_resource_group.disks.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "W. Europe Standard Time"

  notification_settings {
    enabled = false

  }
  lifecycle {
    ignore_changes = [enabled, daily_recurrence_time, timezone, notification_settings]
  }
}
