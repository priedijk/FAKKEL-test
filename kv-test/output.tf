output "kvhex" {
  value = random_id.kvname.hex
}

output "rg_name" {
  value = azurerm_resource_group.fakkel.name
}

output "kv_name" {
  value = azurerm_key_vault.fakkel.name
}
