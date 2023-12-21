
variable "fileshare_folders" {
  type    = map(list(string))
  default = {}
  validation {
    condition = alltrue([
    for folder in values(var.fileshare_folders) : length(folder) > 0])
    error_message = "At least one folder name must be specified per fileshare"
  }
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

variable "tenant" {
  description = "tenant"
  type        = string
  default     = "ae"
}

variable "tags" {
  type = map(string)
  default = {
    "version"     = "test"
    "environment" = "nonprod"
  }
}

