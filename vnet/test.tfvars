outputtest = "vars-variable"

address_space = {
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