variable "new_deployment" {
  description = "new deployment tick"
  type        = bool
  default     = false
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

variable "location" {
  description = "Location of resources"
  type        = string
  default     = "West Europe"
}

variable "dns_zones" {
  type = list(string)
  default = [
    "privatelink.api.azureml.ms",
    "privatelink.azuresynapse.net",
  ]
}
