resource "azurerm_resource_group" "module" {
  name     = "module-sa-test"
  location = "westeurope"
}

module "storage_account_test" {
  source = "./module"

  # These values need to be input by user:
  resource_group_name = "module-sa-test"
  application         = "autosatest"
  environment         = "dev"

  # These values need to be input to use Private endpoint
  # blob_container_names = ["dev"]
  fileshare_names = ["dev", "test"]

  depends_on = [azurerm_resource_group.module]
}

# output "fileshare_name_indexed" {
#   value = module.storage_account_test.fileshares_names
# }

# output "fileshare_names" {
#   value = module.storage_account_test.fileshare_names
# }

output "blob_info" {
  value = module.storage_account_test.blob
}

# output "blob1" {
#   value = module.storage_account_test.blob.blobs["dev"].name
# }

output "fileshare_info" {
  value = module.storage_account_test.fileshare
}

