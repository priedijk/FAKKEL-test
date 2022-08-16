locals {
  peanut = var.location == "frc" ? "yes" : "no"
}

resource "azurerm_resource_group" "vnet-rg" {
  name     = "tf-import-test"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = ["10.20.0.0/16"]

  tags = {
    tag1 = "value1",
    tag2 = "value2"
  }
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.0/24"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = ["10.20.0.32/24"]
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
