locals {
  tags_eventhub_nonprod = merge(var.tags, tomap(
    {
      "active_send_key" = "key1"
      # "eventhub_nonprod" = "${format("%03d", 0 + local.evh_count_nonprod)}"
  }))
}


resource "random_id" "storage_account" {
  byte_length = 3
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.location_code}-1"
  location = var.resource_group_location
  tags     = local.tags_eventhub_nonprod
}


# resource "azurerm_resource_group" "rg" {
#   count    = 2
#   name     = "rg-${var.location_code}-${format("%03d", count.index + 1)}"
#   location = var.resource_group_location
# }


# resource "azurerm_resource_group" "rg2" {
#   name     = "rg-${var.location_code}-2"
#   location = var.resource_group_location
#   tags = {
#     "name" = "one1"
#     "test" = "value"
#   }
# }

# resource "azurerm_resource_group" "rg" {
#   name     = "rg-${var.location_code}"
#   location = var.resource_group_location
#   tags = {
#     "encoded" = var.decode
#     "decoded" = base64decode(var.decode)
#   }
# }

# resource "azurerm_resource_group" "rg3" {
#   name     = "rg-${var.location_code}-3"
#   location = var.resource_group_location
#   tags = {
#     "test" = lookup(var.tags, "version") == "test" && var.switch == true ? "indeed" : "diff_value"
#   }
# }
