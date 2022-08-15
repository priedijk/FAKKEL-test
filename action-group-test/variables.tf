
variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "location_code" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "role-id-owner" {
  type    = string
  default = "8e3af657-a8ff-443c-a75c-2fe8c4bcb630"
}