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
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "location_code" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "tenant" {
  description = "tenant"
  type        = string
  default     = "ae"
}

variable "address_space" {
  type = map(string)
}
variable "address_space2" {
  type = map(list(string))
}
