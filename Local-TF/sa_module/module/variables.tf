##################################################################################################
#
# Variables for Data Sources.
#
##################################################################################################

variable "resource_group_name" {
  description = "Specifies name of Resource Group Name where the Storage account will be deployed."
  type        = string
}

##################################################################################################
#
# Variables for Storage account (naming,...)
#
##################################################################################################

variable "application" {
  description = "Specifies the application name that the Storage account, as part of naming convention pattern `st<application><env><name_suffix>`. The value of `<application>` is alphanumeric string and must not exceed 11 characters."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,11}$", var.application))
    error_message = <<EOF
    "The value of <application> must be between 3 to 11 alphanumeric characters.
     Example: advautotest"
    EOF
  }
}

variable "environment" {
  description = "Specifies the environment to which the Storage account belongs, as part of naming convention pattern `st<application><env><name_suffix>`. Possible values are: `prd`, `fve`, `vte`, `tre`, `npe`, `acp`, `cae`, `ite`, `dev`, `ete`."
  type        = string
  validation {
    condition     = contains(["prd", "fve", "vte", "tre", "npe", "acp", "cae", "ite", "dev", "ete"], var.environment)
    error_message = <<EOF
    "Invalid value specified.
    The value of <env> must be among the list of validated values, which are: `prd`, `fve`, `vte`, `tre`, `npe`, `acp`, `cae`, `ite`, `dev`, `ete`."
    EOF
  }
}

variable "account_tier" {
  description = "Tier of the Storage Account."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard"], var.account_tier)
    error_message = "Invalid Storage Account tier. Can only be Standard."
  }
}

variable "account_replication_type" {
  description = "Replication option for the Storage Account: Local Redundant Storage, Geo-Redundant Storage, Read-Access Geo-Redundant Storage and Zone-Redundant Storage. Available options are: LRS, GRS, RAGRS, ZRS."
  type        = string
  default     = "ZRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.account_replication_type)
    error_message = "Invalid Storage Account replication type. Can only be either LRS, GRS, RAGRS or ZRS."
  }
}

variable "account_kind" {
  description = "SKU of the Storage Account."
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["StorageV2"], var.account_kind)
    error_message = "Invalid Storage Account SKU. Can only be StorageV2."
  }
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled. "
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
}

variable "point_in_time_restore_enabled" {
  description = "Is Point-in-time restore for containers is enabled? Default to `false`"
  type        = bool
  default     = false
}

variable "restore_policy_days" {
  description = "Specifies the number of days that the blob can be restored, between `1` and `364` days. Defaults to 13"
  type        = number
  default     = 13
}

variable "blob_soft_delete_enabled" {
  description = "Is Blob delete retention policy is enabled? Default to `false`"
  type        = bool
  default     = false
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to 14"
  type        = number
  default     = 14
}

variable "container_soft_delete_enabled" {
  description = "Is Container delete retention policy is enabled? Default to `false`"
  type        = bool
  default     = false
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the container should be retained, between `1` and `365` days. Defaults to 14"
  type        = number
  default     = 14
}

variable "versioning_enabled" {
  type        = bool
  description = "Is versioning enabled? Default to `true`"
  default     = true
}

variable "last_access_time_enabled" {
  type        = bool
  description = "Is the last access time based tracking enabled? Default to `true`"
  default     = true
}

variable "change_feed_enabled" {
  type        = bool
  description = "Is the blob service properties for change feed events enabled? Default to `true`"
  default     = true
}

variable "fileshare_soft_delete_enabled" {
  description = "Is File Share delete retention policy is enabled? Default to `true`"
  type        = bool
  default     = true
}

variable "fileshare_soft_delete_retention_days" {
  description = "Specifies the number of days that the fileshare should be retained, between `1` and `365` days. Defaults to 7"
  type        = number
  default     = 7
}

variable "blob_container_names" {
  description = "A list of names of Blob Storage Containers to create inside the provisioned Storage Account."
  type        = list(string)
  default     = []
}

variable "queue_names" {
  description = "The name of the Queue which should be created within the Storage Account."
  type        = list(string)
  default     = []
}

variable "table_names" {
  description = "The name of the storage table. Only Alphanumeric characters allowed, starting with a letter."
  type        = list(string)
  default     = []
}

variable "fileshare_names" {
  description = "The name of the file share. Must be unique within the storage account where the file share is located."
  type        = list(string)
  default     = []
}

variable "access_tier" {
  description = "(Optional) The access tier of the File Share. Possible values are Hot, Cool and TransactionOptimized, Premium."
  type        = string
  validation {
    condition     = contains(["Hot", "Cool", "TransactionOptimized", "Premium"], var.access_tier)
    error_message = "Invalid Storage Account access tier of the share. Can only be either Hot, Cool, TransactionOptimized or Premium."
  }
  default = "TransactionOptimized"
}

variable "enabled_protocol" {
  description = "(Optional) The protocol used for the share. Possible values are SMB and NFS."
  type        = string
  validation {
    condition     = contains(["SMB", "NFS"], var.enabled_protocol)
    error_message = "Invalid the share protocol. Can only be either Standard or Premium."
  }
  default = "SMB"
}

variable "quota" {
  description = " (Required) The maximum size of the share, in gigabytes."
  type        = number
  default     = 5120
}

##################################################################################################
#
# Variable for Private endpoints
#
##################################################################################################
variable "subnet_name" {
  description = "(optional) The name of the subnet in case of non-standard landingzone"
  type        = string
  default     = "DataSubnet"
}

##################################################################################################
#
# Variable for Keyvault
#
##################################################################################################

variable "secret_data" {
  type        = bool
  default     = false
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

##################################################################################################
#
# Variable for Tagging.
#
##################################################################################################

locals {
  filteredtags = { for k in var.inherited_tags : k => lookup(data.azurerm_subscription.subscription_self.tags, k, "undefined") }
  tags         = merge(local.filteredtags, var.custom_tags, tomap({ "createdby" = "automation2.0" }), tomap({ "module_name" = local.module_name, "module_version" = local.module_version }))
}

variable "custom_tags" {
  description = "Specifies a list of key-value pairs to define additional Tags for the resource."
  type        = map(string)
  default     = {}
}

variable "inherited_tags" {
  type    = list(any)
  default = ["owner", "cloudscope", "environment", "businessunit", "tenant"]
}
