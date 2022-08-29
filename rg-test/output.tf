output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "range" {
  value = var.address_space.vnet
}
output "range-replaced" {
  value = replace(var.address_space.vnet, "0.0/24", "0.64/26")
}