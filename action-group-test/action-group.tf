locals {
  email_receiver_group      = var.location_code == "frc" ? local.single_email : local.multiple_emails
  email_receiver_group-test = var.location_code == "frc" ? var.single_email : var.multiple_emails

  single_email = [
    { name = "single", email_address = "single@test.nl", use_common_alert_schema = true }
  ]

  multiple_emails = [
    { name = "test1", email_address = "123@test.nl", use_common_alert_schema = true },
    { name = "test2", email_address = "456@test.nl", use_common_alert_schema = true }
  ]
  local1 = "peanut"
}



resource "azurerm_resource_group" "action-group-rg" {
  name     = "action-group-rg-resources"
  location = var.resource_group_location
}

resource "azurerm_monitor_action_group" "test-group" {
  count               = var.location_code == "weu" && local.local1 != "peanut" ? 1 : 0
  name                = "action-test-after-name-change"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  short_name          = "testgroup1"
}

resource "azurerm_monitor_action_group" "action-group" {
  name                = "action-group-rg-testcase"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  short_name          = "shortername-test"

  dynamic "arm_role_receiver" {
    for_each = var.location_code == "frc" ? [] : [1]
    content {
      name                    = "AzureAdvisorAlerts${var.location_code}"
      role_id                 = var.role-id-owner
      use_common_alert_schema = true
    }
  }

  dynamic "email_receiver" {
    for_each = local.email_receiver_group-test
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = true
    }
  }
}
