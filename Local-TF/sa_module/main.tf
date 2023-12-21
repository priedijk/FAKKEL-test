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
  blob_container_names = ["dev"]
  fileshare_names      = ["dev", "test"]

  depends_on = [azurerm_resource_group.module]
}

output "fileshare_name_indexed" {
  value = module.storage_account_test.fileshares_names
}

output "fileshare_names" {
  value = module.storage_account_test.fileshare_names
}

# Create folder within fileshare
resource "azurerm_storage_share_directory" "example" {
  name                 = "example"
  share_name           = module.storage_account_test.fileshares_names[0]
  storage_account_name = module.storage_account_test.name
}

resource "azurerm_storage_share_directory" "example2" {
  name                 = "example2"
  share_name           = module.storage_account_test.fileshare_names["test"].name
  storage_account_name = module.storage_account_test.name
}
