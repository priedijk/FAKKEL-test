locals {
  tags_eventhub = merge(var.tags, tomap(
    {
      "active_send_key" = "1"
      "workspace"       = "${terraform.workspace}"

  }))
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${terraform.workspace}"
  location = var.resource_group_location
  tags     = local.tags_eventhub

}
