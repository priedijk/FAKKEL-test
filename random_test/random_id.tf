
resource "random_id" "random" {
  byte_length = 3
}

resource "azurerm_resource_group" "secret" {
  name     = "random-id-test"
  location = "westeurope"
  tags = {
    test1 = "key-${lower(random_id.random.b64_std)}" # "test1": "key-g8e=",
    test2 = "key-${lower(random_id.random.b64_url)}" # "test2": "key-g8e",
    test3 = "key-${lower(random_id.random.dec)}"     # "test3": "key-33729",
    test4 = "key-${lower(random_id.random.hex)}"     # "test4": "key-83c1",
    test5 = "key-${lower(random_id.random.id)}"      # "test5": "key-g8e"
  }
}
