data "azurerm_eventhub_namespace" "eventhub" {
  name                = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = azurerm_resource_group.rg.name
}

