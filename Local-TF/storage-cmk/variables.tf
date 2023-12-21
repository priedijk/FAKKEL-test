variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account."
  default     = "stcstorageaccountmk"
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

variable "vm_auto_shutdown_enabled" {
  description = "To enable auto shutdown schedule to reduce VM costs on Dev machines"
  type        = bool
  default     = true
}

variable "new_deployment" {
  description = "new deployment tick"
  type        = string
  default     = "empty"
}

variable "resource_group_name_prefix" {
  default     = "reg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "northeurope"
  description = "Location of the resource group."
}

variable "location_code" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "test" {
  description = "Location code identifier"
  type        = string
  default     = "test30"
}

variable "tenant" {
  description = "tenant"
  type        = string
  default     = "ae"
}

variable "decode" {
  type = string
  # weu
  default = "aGVscDE="
}

variable "nsg" {
  type = map(string)
  default = {
    nsg_name1 = "test1"
    nsg_name2 = "test3"
  }
}

variable "tags" {
  type = map(string)
  default = {
    "version"     = "test"
    "environment" = "nonprod"
  }
}

variable "sku" {
  description = "Defines which tier to use. Valid options are Basic,Standard and Premium."
  default     = "Standard"
}

variable "capacity" {
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  type        = number
  default     = 2
}
