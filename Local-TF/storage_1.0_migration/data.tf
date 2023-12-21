data "azurerm_resource_group" "infra_resource_group" {
  name = var.infra_resource_group_name
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.infra_resource_group_name
  virtual_network_name = var.vnet_name
}


data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.infra_resource_group_name
}

data "azurerm_monitor_action_group" "action_group" {
  count               = var.action_group_present == true ? 1 : 0
  resource_group_name = var.infra_resource_group_name
  name                = var.action_group_name
}
