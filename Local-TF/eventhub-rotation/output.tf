output "resourcegroup" {
  value = azurerm_resource_group.rg.name
}

output "eventhub_namespace_tags" {
  value = data.azurerm_eventhub_namespace.eventhub.tags
}

output "eventhub_namespace_auth_key" {
  value     = data.azurerm_eventhub_namespace.eventhub.default_primary_key
  sensitive = true
}
