output "id" {
  description = "Azure Resource ID of Storage Account"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "Name of Storage Account"
  value       = azurerm_storage_account.storage_account.name
}

output "resource_group_name" {
  description = "Name resource group of Storage Account"
  value       = azurerm_storage_account.storage_account.resource_group_name
}

output "primary_blob_endpoint" {
  description = "Primary Blob endpoint of Storage Account"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "secondary_blob_endpoint" {
  description = "Secondary Blob endpoint of Storage Account"
  value       = azurerm_storage_account.storage_account.secondary_blob_endpoint
}

output "blob_containers_ids" {
  description = "List of Storage Container IDs"
  value       = [for blob in azurerm_storage_container.blob_containers : blob.id]
}

output "blob_containers_names" {
  description = "List of Storage Container names"
  value       = [for blob in azurerm_storage_container.blob_containers : blob.name]
}

output "queues_ids" {
  description = "List of Storage queue IDs"
  value       = [for queue in azurerm_storage_queue.queues : queue.id]
}

output "queues_names" {
  description = "List of Storage queue names"
  value       = [for queue in azurerm_storage_queue.queues : queue.name]
}

output "tables_ids" {
  description = "List of Storage table IDs"
  value       = [for table in azurerm_storage_table.tables : table.id]
}

output "tables_names" {
  description = "List of Storage table names"
  value       = [for table in azurerm_storage_table.tables : table.name]
}

output "fileshares_ids" {
  description = "List of Storage file share IDs"
  value       = [for fileshare in azurerm_storage_share.fileshares : fileshare.id]
}

output "fileshares_names" {
  description = "List of Storage file share names"
  value       = [for fileshare in azurerm_storage_share.fileshares : fileshare.name]
}


output "fileshare_names" {
  description = "List of Storage file share names"
  value = { for fileshare in azurerm_storage_share.fileshares : fileshare.name => {
    id   = fileshare.id
    name = fileshare.name
    }
  }
}
