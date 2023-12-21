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

variable "linux_fx_runtime" {
  type    = string
  default = "JAVA"
}

variable "linux_fx_version" {
  type    = string
  default = "11-java11"
}

variable "app_service_name" {
  type    = string
  default = "as-test-sc0990154445"
}

variable "app_service_name2" {
  type    = string
  default = "as-ite-sc0990174747"
}

variable "app_service_name3" {
  type    = string
  default = "as-prod-sc0990132525"
}

variable "app_service_name4" {
  type    = string
  default = "as-dev-sc0990100099"
}
