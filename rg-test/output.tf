output "resource_group_name" {
  value = data.azurerm_resource_group.rg[0].name
}

output "range" {
  value = var.address_space.vnet
}
output "range-replaced" {
  value = replace(var.address_space.vnet, var.address_space.replace, var.address_space.test)
}

output "shared_key" {
  value = var.shared_key
}
