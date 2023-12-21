variable "new_deployment" {
  description = "new deployment tick"
  type        = string
  default     = "empty"
}

variable "status" {
  description = "create or destroy agw"
  type        = string
  default     = "create"
}
variable "resource_group_name_prefix" {
  default     = "reg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "northeurope"
  description = "Location of the resource group."
}

variable "location" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
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

variable "team" {
  description = "team"
  type        = string
  default     = "team"
}

variable "decode" {
  type = string
  # weu
  default = "aGVscDE="
}

variable "tags" {
  type = map(string)
  default = {
    "version" = "test"
  }
}

# variable "address_space" {
#   type = map(object({
#     regional_space           = string
#     address_space            = string
#     local_gateway_ip_address = string
#     local_address_space      = list(string)
#   }))
# }

variable "address_space" {
  type = map(object({
    regional_space           = string
    address_space            = string
    local_gateway_ip_address = string
    local_address_space      = list(string)
  }))
  default = {
    "weu_ae" = {
      regional_space           = "10.20.0.0/16"
      address_space            = "10.20.0.0/16"
      local_gateway_ip_address = "171.1.2.3"
      local_address_space      = ["171.1.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    },
    "frc_ae" = {
      regional_space           = "10.20.0.0/16"
      address_space            = "10.0.2.0/26"
      local_gateway_ip_address = "171.1.2.3"
      local_address_space      = ["171.1.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    },
    "weu_prod" = {
      regional_space           = "10.20.0.0/16"
      address_space            = "10.20.0.0/16"
      local_gateway_ip_address = "171.1.2.3"
      local_address_space      = ["171.1.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    },
    "frc_prod" = {
      regional_space           = "10.20.0.0/16"
      address_space            = "10.0.0.0/26"
      local_gateway_ip_address = "171.1.2.3"
      local_address_space      = ["171.1.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    }
  }
}

variable "network_weu_ae" {
  type = map(object({
    subnet_name        = string
    subnet_address     = string
    bastion            = string
    nsg                = string
    service_endpoint   = list(string)
    service_delegation = string
  }))
  default = {
    "GatewaySubnet" = {
      subnet_name        = "GatewaySubnet",
      subnet_address     = "10.20.0.32/27"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_endpoint   = ["Microsoft.Storage"]
      service_delegation = null
    }
    "agw" = {
      subnet_name        = "agw",
      subnet_address     = "10.20.6.0/24"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_endpoint   = null
      service_delegation = null
    }
  }
}

variable "shared_key" {
  type    = string
  default = "ihgwoih803247d8jal"
}

variable "Ingress_ip_list" {
  type    = list(string)
  default = ["10.10.10.19/32", "10.10.10.20/32", "10.10.10.21/32"]
}
