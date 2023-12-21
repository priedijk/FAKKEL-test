variable "prefix" {
  default = "test-automation"
}

locals {
  rg_name = "${var.prefix}-vm"

  flat_fileshare_folders = flatten([
    for fileshare, folders in var.fileshare_folders : [
      for folder in folders : {
        fileshare = fileshare
        folder    = folder
      }
    ]
  ])
}

resource "azurerm_resource_group" "rg" {
  # no need to check for additional length of the fileshare_folders var
  for_each = {
    for folder_item in local.flat_fileshare_folders : "${folder_item.fileshare}-${folder_item.folder}" => folder_item
  }
  name     = "resources-${each.value.fileshare}-${each.value.folder}"
  location = "West Europe"
  tags = {
    "inFileshare" = "${each.value.fileshare}"
    "folder"      = "${each.value.folder}"
  }
}

# output "length_output" {
#   value = local.length_item
# }
