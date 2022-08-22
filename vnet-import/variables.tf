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
    regional_space = string
    address_space  = string
  }))
  default = {
    "weu_ae" = {
      regional_space = "10.20.0.0/16"
      address_space  = "10.20.0.0/16"
    },
    "frc_ae" = {
      regional_space = "10.20.0.0/16"
      address_space  = "10.0.2.0/26"
    },
    "weu_prod" = {
      regional_space = "10.20.0.0/16"
      address_space  = "10.20.0.0/16"
    },
    "frc_prod" = {
      regional_space = "10.20.0.0/16"
      address_space  = "10.0.0.0/26"
    }
  }
}

variable "network_weu_ae" {
  type = map(object({
    subnet_name    = string
    subnet_address = string
    bastion        = string
    bastion2        = string
  }))
  default = {
    "firewall" = {
      subnet_name    = "AzureFirewallSubnet"
      subnet_address = "10.20.0.0/27"
      bastion        = "10.20.0.64/27"
      bastion2        = replace(bastion, "0.64/27", "1.64/28")
    },
    "gateway" = {
      subnet_name    = "GatewaySubnet",
      subnet_address = "10.20.0.32/27"
      bastion        = "10.20.0.64/27" 
      bastion2       = null  
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
      destination_port_ranges    = ["8080","7050"]
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
  }
}