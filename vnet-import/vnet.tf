locals {
  peanut = var.location_code == "weu" ? "yes" : "no"
}

resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.location
}

resource "azurerm_network_security_group" "nsg" {
  name                = "vnet-rg-security-group"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "vnet-rg-network"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = ["10.20.0.0/16"]

  subnet {
    name           = "AzureFirewallSubnet"
    address_prefix = "10.20.0.0/24"
  }

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.20.0.32/24"
  }

  tags = {
    tag1 = "value1",
    tag2 = "value2"
  }
}

/*
resource "azurerm_monitor_action_group" "test-group" {
  count               = var.location_code == "weu" && local.local1 != "peanut" ? 1 : 0
  name                = "action-test"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  short_name          = "testgroup1"
}

resource "azurerm_monitor_action_group" "action-group" {
  name                = "action-group-rg-"
  resource_group_name = azurerm_resource_group.action-group-rg.name
  short_name          = "shortername"

  dynamic "arm_role_receiver" {
    for_each = var.location_code == "frc" ? [] : [1]
    content {
      name                    = "AzureAdvisorAlerts${var.location_code}"
      role_id                 = var.role-id-owner
      use_common_alert_schema = true
    }
  }
}
*/
