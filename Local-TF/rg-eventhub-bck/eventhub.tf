locals {
  evh_sku           = "Premium"
  evh_capacity      = "1"
  evh_count_nonprod = 1
  evh_count_prod    = 1
}

resource "azurerm_eventhub_namespace" "nonprod" {
  count                    = var.location_code == "weu" ? local.evh_count_nonprod : 0
  name                     = "pskekkel-nonprod-${var.location_code}-${format("%03d", count.index + 1)}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  sku                      = local.evh_sku
  auto_inflate_enabled     = null
  maximum_throughput_units = null
  zone_redundant           = true
  capacity                 = local.evh_capacity
  # tags                = local.tags_eventhub_nonprod
  tags = merge(local.tags_eventhub_nonprod, tomap(
    {
      "eventhub_nonprod" = "${format("%03d", count.index + 1)}"
      "location"         = var.location_code
      "logicalname"      = "eventhub-shared"
  }))
  minimum_tls_version = "1.2"
  network_rulesets {
    public_network_access_enabled  = true
    trusted_service_access_enabled = true
    default_action                 = "Deny"
    virtual_network_rule           = []

    ip_rule = [
      for range in sort(var.address_space_list) : {
        ip_mask = range
        action  = "Allow"
      }
    ]
  }
  lifecycle {
    ignore_changes = [
      capacity,
      # tags["active_send_key"]
    ]
  }
}

resource "azurerm_eventhub" "applog_nonprod" {
  count               = var.location_code == "weu" ? local.evh_count_nonprod : 0
  name                = "evh-proulog-nonprod-${var.location_code}-${format("%03d", count.index + 1)}"
  namespace_name      = azurerm_eventhub_namespace.nonprod[count.index].name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 18
  message_retention   = 7
}
