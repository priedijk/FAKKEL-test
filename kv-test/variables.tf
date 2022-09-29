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
