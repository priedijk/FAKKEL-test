variable "location" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "tenant" {
  description = "Location code identifier"
  type        = string
  default     = "ae"
}
variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "vnet_address_space" {
  type = map(object({
    address_space = string
  }))
  default = {
    "weu_ae" = {
      address_space = "10.20.0.0/16"
    },
    "frc_ae" = {
      address_space = "10.0.2.0/26"
    },
    "weu_prod" = {
      address_space = "10.20.0.0/16"
    },
    "frc_prod" = {
      address_space = "10.0.2.0/26"
    }
  }
}

variable "network_weu_ae" {
  type = map(object({
    subnet_name    = string
    subnet_address = string
  }))
  default = {
    "firewall" = {
      subnet_name    = "AzureFirewallSubnet"
      subnet_address = "10.20.0.0/27"
    },
    "gateway" = {
      subnet_name    = "GatewaySubnet",
      subnet_address = "10.20.0.32/27"
    }
  }
}