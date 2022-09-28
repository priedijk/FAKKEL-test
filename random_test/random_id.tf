
resource "random_id" "random" {
  byte_length = 2
}

resource "azurerm_resource_group" "secret" {
  name     = "random-id-test"
  location = "westeurope"
  tags = {
    test1 = "key-${lower(random_id.random.b64_std)}"
    test2 = "key-${lower(random_id.random.b64_url)}"
    test3 = "key-${lower(random_id.random.dec)}"
    test4 = "key-${lower(random_id.random.hex)}"
    test5 = "key-${lower(random_id.random.id)}"
  }
}
