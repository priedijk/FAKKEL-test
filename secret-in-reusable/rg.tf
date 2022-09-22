data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "secret" {
  name     = "secret-test"
  location = "westeurope"
  tags = {
    key   = var.shared_key
    test1 = var.testput1
    test2 = base64decode(var.testput2)
    test3 = var.testput3
  }
}
