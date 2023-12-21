locals {
  tags_eventhub = merge(var.tags, tomap(
    {
      "active_send_key" = "key1"
      "environment"     = "nonprod"
      "logicalname"     = "keyvault-app"
  }))
  eventhub_key = lookup(data.azurerm_eventhub_namespace.eventhub.tags, "active_send_key") == "key1" ? data.azurerm_eventhub_namespace.eventhub.default_primary_key : data.azurerm_eventhub_namespace.eventhub.default_secondary_key

}

resource "azurerm_resource_group" "rg" {
  name     = "rg-evhns-rotation-001"
  location = var.resource_group_location
  tags     = local.tags_eventhub
}

resource "azurerm_eventhub_namespace" "eventhub" {
  name                = "evhns-rotation-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.sku
  capacity            = var.capacity
  tags                = local.tags_eventhub
  minimum_tls_version = var.location_code_test == "frc" ? "1.2" : null
}

resource "azurerm_eventhub" "eventhub" {
  name                = "evh-rotation-001"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 2
}

resource "azurerm_eventhub_authorization_rule" "eventhub" {
  name                = "sendonly"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "managediag" {
  name                = "managediag"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = true
  manage              = true
}

resource "azurerm_eventhub_namespace_authorization_rule" "managediag_test" {
  name                = "managediagtest"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = true
  manage              = true
}

# resource "azurerm_resource_group" "conditional" {
#   name     = "rg-evhns-001"
#   location = var.resource_group_location
#   tags     = { "active_send_key" = lookup(data.azurerm_eventhub_namespace.eventhub.tags, "active_send_key") }
# }
