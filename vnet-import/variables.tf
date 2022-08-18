variable "location" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
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

/*
variable "subnets" {
  type = map(object({
    subnet_name    = string
    address_prefix = string
  }))
  default = {
    firewall = {
      subnet_name    = "AzureFirewallSubnet",
      address_prefix = "10.20.0.0/27"
    }
    gateway = {
      subnet_name    = "GatewaySubnet",
      address_prefix = "10.20.0.32/27"
    }
  }
}

variable "network" {
  type = map(object({
    address_space = string
    subnets = list(object({
      subnet_name    = string
      subnet_address = string
    }))
  }))

  default = {
    "import-vnet" = {
      address_space = "10.20.0.0/16",
      subnets = [
        {
          subnet_name    = "AzureFirewallSubnet"
          subnet_address = "10.20.0.0/27"
        },
        {
          subnet_name    = "GatewaySubnet"
          subnet_address = "10.20.0.32/27"
        }
      ]
    }
  }
}
*/
