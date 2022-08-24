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
    service_delegation = string
  }))
  default = {
    "AzureFirewallSubnet" = {
      subnet_name        = "AzureFirewallSubnet"
      subnet_address     = "10.20.0.0/27"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_delegation = "Microsoft.DBforPostgreSQL/flexibleServers"
    },
    "GatewaySubnet" = {
      subnet_name        = "GatewaySubnet",
      subnet_address     = "10.20.0.32/27"
      bastion            = "10.20.0.64/27"
      nsg                = null
      service_delegation = null
    }
    "troep" = {
      subnet_name        = "troep",
      subnet_address     = "10.20.0.96/27"
      bastion            = "10.20.0.64/27"
      nsg                = "apim"
      service_delegation = null
    }
  }
}

variable "nsg" {
  type = map(string)
  default = {
    nsg_name1 = "test1"
    nsg_name2 = "test2"
  }
}

variable "nsg_rules_bastion" {
  type = map(object({
    name                       = string
    description                = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    destination_port_ranges    = list(string)
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {
    "AllowWebExperienceInBound" = {
      name                       = "AllowWebExperienceInBound"
      description                = ""
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      destination_port_ranges    = null
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    "AllowControlPlaneInBound" = {
      name                       = "AllowControlPlaneInBound"
      description                = ""
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = null
      destination_port_ranges    = ["8080", "7050"]
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
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