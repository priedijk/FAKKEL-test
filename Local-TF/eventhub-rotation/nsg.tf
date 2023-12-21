resource "azurerm_network_security_group" "example" {
  name                = "test-nsg-diag"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-diags"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  name                           = "diag-nsg-example"
  target_resource_id             = azurerm_network_security_group.example.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.example.id
  eventhub_name                  = azurerm_eventhub.eventhub.name
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.managediag.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }
  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}


