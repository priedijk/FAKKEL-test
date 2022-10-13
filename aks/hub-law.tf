
resource "random_id" "lawname" {
  byte_length = 4
}

resource "azurerm_log_analytics_workspace" "hub" {
  name                = "law${random_id.lawname.hex}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "PerGB2018"
  retention_in_days   = 31
}