variable "eventhubs_shared" {
  type = map(object({
    sku               = string
    capacity          = number
    instance_count    = number
    partition_count   = number
    message_retention = number
  }))
  default = {
    "nonprod" = {
      sku               = "Standard"
      capacity          = 1
      instance_count    = 1
      partition_count   = 4
      message_retention = 7
    },
    "prod" = {
      sku               = "Standard"
      capacity          = 4
      instance_count    = 1
      partition_count   = 8
      message_retention = 14
    }
  }
}

variable "eventhub_namespace_shared" {
  type = map(object({
    location       = string
    prefix         = string
    instance_count = number
    test           = bool
    test1          = number
  }))
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

variable "address_space" {
  type = map(string)
  default = {
    "replace" = "10.100.0.0/24"
    "replace" = "0.0/24"
    "test"    = "0.64/26"
    "rg_name" = "pluto"
  }
}

variable "switch" {
  type    = bool
  default = true
}
