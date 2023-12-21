variable "infra_resource_group_name" {
  description = "Resrouce group where the infra subnets are hosted"
}


variable "resource_group_name" {
  description = "Resource Group Name where the storage account is deployed"
}


variable "vnet_name" {
  description = "The name of the vnet where the private endpoint should exist"
  type        = string
}

variable "subnet_name" {
  description = "The Name of the Subnet where the private endpoint should exist"
  type        = string
}

variable "private_subnet_id" {
  description = "The Subnet id from which to access the Blob API"
  type        = string
  default     = ""
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account."
}

variable "environment" {
  type        = string
  description = "(optional) The name of the environment where to create the resource."
  default     = ""
}


variable "account_kind" {
  type        = string
  description = "Defines the Kind of account."
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. "
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  default     = "ZRS"
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts."
  default     = "Hot"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled, "
  default     = true
}

variable "allow_blob_public_access" {
  type        = bool
  description = "Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
  default     = false
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the container should be retained, between `1` and `365` days. Defaults to 14"
  default     = 14
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to 14"
  default     = 14
}

variable "enable_versioning" {
  type        = bool
  description = "Is versioning enabled? Default to `false`"
  default     = true
}

variable "last_access_time_enabled" {
  type        = bool
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = true
}

variable "change_feed_enabled" {
  type        = bool
  description = "Is the blob service properties for change feed events enabled?"
  default     = true
}

variable "private_dns_zone_ids" {
  description = "The ID of the privatelink DNS zone in Azure to register the Private Endpoint resource type."
  type        = list(string)
}

variable "is_blob_soft_delete_enabled" {
  description = "Is Blob delete retention policy is enabled?"
  type        = string
  default     = "no"
}

variable "is_container_soft_delete_enabled" {
  description = "Is Container delete retention policy is enabled?"
  type        = string
  default     = "no"
}


variable "keyvault_name" {
  description = "Name of the keyvault where the secrets are stored"
  type        = string
}

variable "log_retention_in_days" {
  description = "log retention period in days"
  type        = number
  default     = 0
}

variable "subresource_names" {
  description = "A list of subresource names which the Private Endpoint is able to connect to"
  type        = list(string)
  default     = ["blob"]
}

variable "storage_type" {
  description = "Storage Type, Valid values blob, file"
  type        = string
  default     = "blob"
}

variable "action_group_name" {
  description = "Name of the Action group where alert needs to be attached"
  type        = string
}

variable "action_group_present" {
  description = "Flag to check if action group is present or not"
  default     = true
  type        = bool
}

variable "secret_data" {
  type        = bool
  default     = true
  description = "(optional) required to enable Customer-managed key data encryption"
}

variable "cmk_key_type" {
  type        = string
  default     = "RSA-HSM"
  description = "Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created"
}

variable "cmk_key_size" {
  type        = string
  default     = "2048"
  description = "(Optional) Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM. Changing this forces a new resource to be created"
}
