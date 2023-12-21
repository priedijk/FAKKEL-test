terraform {
  required_providers {
    azurerm = {
      version = ">= 3.48.0"
    }
  }
}

##################################################################################################
#
# Data Sources.
#
##################################################################################################

data "azurerm_subscription" "subscription_self" {
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}


##################################################################################################
#
# Random string for name_suffix
# Sleep 5 mins before create Blob container, Queue, Table and Fileshare
#
##################################################################################################

resource "random_string" "name_suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "time_sleep" "wait" {
  create_duration = "10s"
}

##################################################################################################
#
# Storage account definition and Blob container, Queue, Table, File share resource
#
##################################################################################################

locals {
  source_location = data.azurerm_resource_group.resource_group.location == "westeurope" ? "weu" : "frc"

  restore_policy_days = var.blob_soft_delete_retention_days > var.restore_policy_days ? var.restore_policy_days : (var.blob_soft_delete_retention_days - 1)

}

resource "azurerm_storage_account" "storage_account" {
  name                            = "stamoduletest${resource.random_string.name_suffix.result}"
  resource_group_name             = data.azurerm_resource_group.resource_group.name
  location                        = data.azurerm_resource_group.resource_group.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  enable_https_traffic_only       = var.enable_https_traffic_only
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
  tags                            = local.tags

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Allow"
  }

  dynamic "identity" {
    for_each = (lower(var.secret_data) ? [1] : [])
    content {
      type = "SystemAssigned"
    }
  }

  blob_properties {
    dynamic "restore_policy" {
      for_each = var.point_in_time_restore_enabled ? [1] : []
      content {
        days = local.restore_policy_days
      }
    }
    dynamic "delete_retention_policy" {
      for_each = (var.point_in_time_restore_enabled || var.blob_soft_delete_enabled) ? [1] : []
      content {
        days = var.blob_soft_delete_retention_days
      }
    }
    dynamic "container_delete_retention_policy" {
      for_each = var.container_soft_delete_enabled ? [1] : []
      content {
        days = var.container_soft_delete_retention_days
      }
    }
    versioning_enabled       = var.point_in_time_restore_enabled ? true : var.versioning_enabled
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.point_in_time_restore_enabled ? true : var.change_feed_enabled
  }

  share_properties {
    dynamic "retention_policy" {
      for_each = var.fileshare_soft_delete_enabled ? [1] : []
      content {
        days = var.fileshare_soft_delete_retention_days
      }
    }
  }

  lifecycle {
    precondition {
      condition     = length(var.blob_container_names) > 0 || length(var.queue_names) > 0 || length(var.table_names) > 0 || length(var.fileshare_names) > 0
      error_message = "At least one of either Blob Container, File Share, Queue or Table must be declared."
    }
  }
}

resource "azurerm_storage_container" "blob_containers" {
  depends_on = [
    azurerm_storage_account.storage_account,
    time_sleep.wait
  ]
  for_each = toset(var.blob_container_names)

  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_queue" "queues" {
  depends_on = [
    azurerm_storage_account.storage_account,
    time_sleep.wait
  ]
  for_each = toset(var.queue_names)

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage_account.name
}

resource "azurerm_storage_table" "tables" {
  depends_on = [
    azurerm_storage_account.storage_account,
    time_sleep.wait
  ]
  for_each = toset(var.table_names)

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage_account.name
}

resource "azurerm_storage_share" "fileshares" {
  depends_on = [
    azurerm_storage_account.storage_account,
    time_sleep.wait
  ]
  for_each = toset(var.fileshare_names)

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage_account.name
  access_tier          = var.access_tier
  enabled_protocol     = var.enabled_protocol
  quota                = var.quota
}
