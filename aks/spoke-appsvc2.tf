
# resource "azurerm_service_plan" "second" {
#   name                = "second-appserviceplan"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   zone_redundant      = true
#   kind                = "Linux"
#   reserved            = true

#   sku {
#     tier = "PremiumV3"
#     size = "P1v3"
#   }
# }



# resource "azurerm_app_service" "main2" {
#   name                = "appsvc2-${random_id.appname.hex}"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   app_service_plan_id = azurerm_service_plan.first.id
#   identity {
#     type = "SystemAssigned"
#   }
#   site_config {
#     vnet_route_all_enabled = true
#     #linux_fx_version       = "TOMCAT|9.0-java11"
#     linux_fx_version = "PHP|7.4"
#   }
#   app_settings = {
#     "WEBSITE_DNS_SERVER" = "168.63.129.16",
#     "environment"        = "prod"
#     "SECRETFROMKEYVAULT" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mysecret.id})"
#   }
# }

# resource "azurerm_app_service" "main3" {
#   name                = "appsvc3-${random_id.appname.hex}"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   app_service_plan_id = azurerm_service_plan.second.id
#   identity {
#     type = "SystemAssigned"
#   }
#   site_config {
#     vnet_route_all_enabled = true
#     #linux_fx_version       = "TOMCAT|9.0-java11"
#     linux_fx_version = "PHP|7.4"
#   }
#   app_settings = {
#     "WEBSITE_DNS_SERVER" = "168.63.129.16",
#     "environment"        = "prod"
#     "SECRETFROMKEYVAULT" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mysecret.id})"
#   }
# }


# resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection2" {
#   app_service_id = azurerm_app_service.main2.id
#   subnet_id      = azurerm_subnet.spoke1int.id
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection3" {
#   app_service_id = azurerm_app_service.main3.id
#   subnet_id      = azurerm_subnet.spoke1int-2.id
# }



# resource "azurerm_private_endpoint" "privateendpoint2" {
#   name                = "webappprivateendpoint2"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   subnet_id           = azurerm_subnet.spoke1end.id
#   private_dns_zone_group {
#     name                 = "privatednszonegroup2"
#     private_dns_zone_ids = [azurerm_private_dns_zone.hubappsvc.id]
#   }
#   private_service_connection {
#     name                           = "privateendpointconnection"
#     private_connection_resource_id = azurerm_app_service.main2.id
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#   }
# }

# resource "azurerm_private_endpoint" "privateendpoint3" {
#   name                = "webappprivateendpoint3"
#   location            = azurerm_resource_group.spoke.location
#   resource_group_name = azurerm_resource_group.spoke.name
#   subnet_id           = azurerm_subnet.spoke1end.id
#   private_dns_zone_group {
#     name                 = "privatednszonegroup3"
#     private_dns_zone_ids = [azurerm_private_dns_zone.hubappsvc.id]
#   }
#   private_service_connection {
#     name                           = "privateendpointconnection"
#     private_connection_resource_id = azurerm_app_service.main3.id
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#   }
# }

