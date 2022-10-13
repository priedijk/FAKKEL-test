data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "secret" {
  name     = "secret-test"
  location = "westeurope"
  tags = {
    key   = var.shared_key
    test2 = base64decode(var.shared_key)
  }
}
