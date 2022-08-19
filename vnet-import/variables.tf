variable "location" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
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
    "weu" = {
      address_space = "10.20.0.0/16"
    },
    "frc" = {
      address_space = "10.0.2.0/26"
    }
  }
}

variable "network" {
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