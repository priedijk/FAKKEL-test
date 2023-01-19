output "kvhex" {
  value = random_id.kvname.hex
}

output "kv_name" {
  value = azurerm_key_vault.fakkel.name
}
