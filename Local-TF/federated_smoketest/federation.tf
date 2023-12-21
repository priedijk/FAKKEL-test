data "azuread_service_principal" "smoketest" {
  display_name = "app_smoketest_001"
}

data "azurerm_storage_account" "tfstate" {
  name                = "tfstatetestfakkel"
  resource_group_name = "tfstatetestfakkel"
}

resource "azurerm_role_assignment" "app_azure_smoketest_blob_reader_tfstate_hub" {
  count                = var.location_code == "weu" ? 1 : 0
  scope                = data.azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azuread_service_principal.smoketest.object_id
}

resource "azuread_application_federated_identity_credential" "smoketest_foundation" {
  application_object_id = "7cd5b792-a0f6-4274-9eb3-4189841e3eaa"
  display_name          = "fic-app_azure_smoketest-001"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:priedijk/FAKKEL-test:environment:fakkel"
}

# resource "azurerm_federated_identity_credential" "smoketest_foundation" {
#   count               = var.location_code == "weu" ? 1 : 0
#   name                = "fic-app_azure_smoketest-001"
#   resource_group_name = azurerm_resource_group.rg.name
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = "https://token.actions.githubusercontent.com"
#   parent_id           = data.azuread_service_principal.smoketest.id
#   subject             = "repo:priedijk/FAKKEL-test:environment:fakkel"
# }
