variable "location" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "subnets" {
  type = map(object({
    name          = string
    email_address = string
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

