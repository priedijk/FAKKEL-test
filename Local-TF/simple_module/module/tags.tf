variable "resource_tags" {
  type        = map(string)
  description = "(optional) Resource tags from Snow"
  default     = {}
}

variable "sysops_tags" {
  type        = map(string)
  description = "(optional) Tags to add to alert"
  default     = {}
}

variable "tags" {
  type        = list(map(string))
  description = "test tags"
}

locals {

  # my_map = zipmap([for item in var.tags : keys(item)], [for item in var.tags : values(item)])
  my_map = zipmap(keys(var.tags[0]), values(var.tags[0]))


  application_services      = [for k, _ in local.my_map : k]
  business_criticalities    = [for _, v in local.my_map : v]
  application_service_tags  = { for i, v in local.application_services : "appliction_service${i + 1}" => v }
  business_criticality_tags = { for i, v in local.business_criticalities : "business_criticality${i + 1}" => v }

  # application_services      = [for k, _ in var.tags : k]
  # business_criticalities    = [for _, v in var.tags : v]
  # application_service_tags  = { for i, v in local.application_services : "appliction_service${i + 1}" => v }
  # business_criticality_tags = { for i, v in local.business_criticalities : "business_criticality${i + 1}" => v }
  # tags                      = merge(var.resource_tags, local.application_service_tags, local.business_criticality_tags)
}
