resource "azurerm_resource_group" "rg_eventhub" {
  name     = "rg-eventhub-${var.location_code}"
  location = var.location
}

resource "azurerm_eventhub" "eventhub" {
  name                = "event-test-${var.location_code}-001"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = azurerm_resource_group.rg_eventhub.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_namespace" "eventhub" {
  name                = "event-namespace-${var.location_code}"
  location            = azurerm_resource_group.rg_eventhub.location
  resource_group_name = azurerm_resource_group.rg_eventhub.name
  sku                 = "Basic"
  zone_redundant      = true
}
