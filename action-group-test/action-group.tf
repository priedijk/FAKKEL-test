locals {
  email_receiver_group = var.location_code == "weu" ? local.single_email : local.multiple_emails

  single_email = [
    { name = single, email_address = "single@test.nl" }
    ]
    
  multiple_emails = [
    { name = test1, email_address = "123@test.nl" },
    { name = test2, email_address = "456@test.nl" },
    ]

}



resource "azurerm_resource_group" "action-group-rg" {
  name     = "action-group-rg-resources"
  location = var.resource_group_location
}

resource "azurerm_monitor_action_group" "action-group" {
  name                = "action-group-rg-"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  short_name          = "shortername"

  dynamic "email_receiver" {
    for_each = local.email_receiver_group
      content {
        name                    = email_receiver.value.name
        email_address           = email_receiver.value.email_address
        use_common_alert_schema = true
      }
  }
}