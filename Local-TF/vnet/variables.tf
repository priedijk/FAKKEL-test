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
    "AzureFirewallSubnet" = {
      subnet_name        = "AzureFirewallSubnet"
      subnet_address     = "10.20.0.0/27"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_endpoint   = null
      service_delegation = "Microsoft.DBforPostgreSQL/flexibleServers"
    },
    "GatewaySubnet" = {
      subnet_name        = "GatewaySubnet",
      subnet_address     = "10.20.0.32/27"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_endpoint   = ["Microsoft.Storage"]
      service_delegation = null
    }
  }
}

variable "nsg_rules_default" {
  type = map(object({
    name                         = string
    description                  = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(string)
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(string)
  }))
  default = {
    "defaultrule" = {
      name                       = "AllowdefaultInBound"
      description                = ""
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }
}
variable "nsg_rules_test" {
  type = map(object({
    name                         = string
    description                  = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(string)
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(string)
  }))
  default = {
    "AllowWebExperienceInBound" = {
      name                       = "AllowWebExperienceInBound"
      description                = ""
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    "AllowControlPlaneInBound" = {
      name                       = "AllowControlPlaneInBound"
      description                = ""
      priority                   = 210
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "7050"]
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    },
    "AllowIngressIPs" = {
      name                       = "AllowIngressIPs"
      description                = ""
      priority                   = 220
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefixes    = "akamai_staging"
      destination_address_prefix = "*"
    },
    "AllowIngressIPs2" = {
      name                         = "AllowIngressIPs2"
      description                  = ""
      priority                     = 230
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefixes      = "akamai_gtm"
      destination_address_prefixes = "local_subnet"
    },
    "AllowIngressIPs3" = {
      name                         = "AllowIngressIPs3"
      description                  = ""
      priority                     = 240
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefixes      = "akamai_siteshield"
      destination_address_prefixes = "local_subnet"
    }
  }
}


variable "ipsec_policy" {
  type = map(object({
    dpd_timeout_seconds = string
    dh_group            = string
    ike_encryption      = string
    ike_integrity       = string
    ipsec_encryption    = string
    ipsec_integrity     = string
    pfs_group           = string
    sa_datasize         = number
    sa_lifetime         = number
  }))
  default = {
    "weu_ae" = {
      dpd_timeout_seconds = 3600
      dh_group            = "DHGroup14"
      ike_encryption      = "AES256"
      ike_integrity       = "SHA256"
      ipsec_encryption    = "AES256"
      ipsec_integrity     = "SHA256"
      pfs_group           = "None"
      sa_datasize         = 2147483647
      sa_lifetime         = 27000
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
