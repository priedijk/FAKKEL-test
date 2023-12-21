# output "resourcegroup" {
#   value = azurerm_resource_group.rg.name
# }

# output "randomid" {
#   value = random_id.storage_account.dec
# }

output "tagvalue" {
  value = lookup(var.tags, "environment") == "nonprod" ? "true_is_nonprod" : "false_is_prod"
}
