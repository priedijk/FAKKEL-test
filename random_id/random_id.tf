
resource "random_id" "random" {
  byte_length = 3
}
resource "random_id" "import" {
  byte_length = 2
}

resource "azurerm_resource_group" "secret" {
  name     = "random-id-test"
  location = "westeurope"
  tags = {
    test1   = "key-${lower(random_id.random.b64_std)}" # "test1": "key-mhfl"
    test2   = "key-${lower(random_id.random.b64_url)}" # "test2": "key-mhfl"
    test3   = "key-${lower(random_id.random.dec)}"     # "test3": "key-3282891"
    test4   = "key-${lower(random_id.random.hex)}"     # "test4": "key-3217cb"
    test5   = "key-${lower(random_id.random.id)}"      # "test5": "key-mhfl"
    import  = "key-${lower(random_id.import.id)}"      # "test5": "key-mhfl"
    import2 = "key-${lower(random_id.import.hex)}"     # "test5": "key-mhfl"
  }
}
