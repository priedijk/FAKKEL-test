# resource "azurerm_subnet" "ase" {
#   name                 = "asesubnet"
#   resource_group_name  = azurerm_resource_group.spoke.name
#   virtual_network_name = azurerm_virtual_network.spoke.name
#   address_prefixes     = ["10.1.20.0/24"]
# }

# resource "azurerm_app_service_environment" "ase1" {
#   name                         = "example-ase"
#   subnet_id                    = azurerm_subnet.ase.id
#   pricing_tier                 = "I2"
#   front_end_scale_factor       = 10
#   internal_load_balancing_mode = "Web, Publishing"
#   allowed_user_ip_cidrs        = ["11.22.33.44/32", "55.66.77.0/24"]

#   cluster_setting {
#     name  = "DisableTls1.0"
#     value = "1"
#   }
# }

# resource "azurerm_subnet" "ase3" {
#   name                 = "outbound"
#   resource_group_name  = azurerm_resource_group.spoke.name
#   virtual_network_name = azurerm_virtual_network.spoke.name
#   address_prefixes     = ["10.1.30.0/24"]

#   delegation {
#     name = "delegation"

#     service_delegation {
#       name    = "Microsoft.Web/hostingEnvironments"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#     }
#   }
# }

# resource "azurerm_app_service_environment_v3" "main1" {
#   name                = "main1-asev3"
#   resource_group_name = azurerm_resource_group.spoke.name
#   subnet_id           = azurerm_subnet.ase3.id

#   cluster_setting {
#     name  = "DisableTls1.0"
#     value = "1"
#   }

#   cluster_setting {
#     name  = "InternalEncryption"
#     value = "true"
#   }

#   cluster_setting {
#     name  = "FrontEndSSLCipherSuiteOrder"
#     value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
#   }
# }

# resource "azurerm_app_service_plan" "aseplan" {
#   name                       = "ase3-plan"
#   location                   = azurerm_resource_group.spoke.location
#   resource_group_name        = azurerm_resource_group.spoke.name
#   kind                       = "Linux"
#   reserved                   = true
#   app_service_environment_id = azurerm_app_service_environment_v3.main1.id
#   sku {
#     tier     = "Isolated"
#     size     = "I1V2"
#     capacity = 1
#     # I1 I2 I3 I1V2 I2V2 I3V2
#   }
# }


# resource "azurerm_app_service" "ase3" {
#   name                = "ase3-${random_id.appname.hex}"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   app_service_plan_id = azurerm_app_service_plan.aseplan.id
#   # identity {
#   #   type = "SystemAssigned"
#   # }
#   site_config {
#     # vnet_route_all_enabled = true
#     linux_fx_version = "PHP|7.4"
#   }
#   # app_settings = {
#   #   "WEBSITE_DNS_SERVER" = "168.63.129.16",
#   #   "environment"        = "prod"
#   #   "SECRETFROMKEYVAULT" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mysecret.id})"
#   # }
# }