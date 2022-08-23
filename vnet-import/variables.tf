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
    subnet_name    = string
    subnet_address = string
    bastion        = string
    nsg            = string
  }))
  default = {
    "firewall" = {
      subnet_name    = "AzureFirewallSubnet"
      subnet_address = "10.20.0.0/27"
      bastion        = "10.20.0.64/27"
      nsg            = null
    },
    "gateway" = {
      subnet_name    = "GatewaySubnet",
      subnet_address = "10.20.0.32/27"
      bastion        = "10.20.0.64/27"
      nsg            = null
    }
    "troep" = {
      subnet_name    = "troep",
      subnet_address = "10.20.0.96/27"
      bastion        = "10.20.0.64/27"
      nsg            = "apim"
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
    dhGroup             = string
    ikeEncryption       = string
    ikeIntegrity        = string
    ipsecEncryption     = string
    ipsecIntegrity      = string
    pfsGroup            = string
    saDataSizeKilobytes = number
    saLifeTimeSeconds   = number
  }))
  default = {
    "weu_ae" = {
      dpd_timeout_seconds = 3600
      dhGroup             = "DHGroup14"
      ikeEncryption       = "AES256"
      ikeIntegrity        = "SHA256"
      ipsecEncryption     = "AES256"
      ipsecIntegrity      = "SHA256"
      pfsGroup            = "None"
      saDataSizeKilobytes = 2147483647
      saLifeTimeSeconds   = 27000
    }
  }
}

variable "shared_key" {
  type        = string
  default     = "ihgwoih803247d8jal"
}