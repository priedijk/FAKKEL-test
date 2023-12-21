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
    }
  }
}

variable "testvar" {
  type = map(object)
  # add default











}
variable "nsg_rules" {
  type = map(map(object({
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

  })))
  # add default

}
