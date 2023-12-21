## Create a random 'word' that will be added to the DNS name of the Public IP of the AppGW (to make it globally uniq)
resource "random_id" "agw" {
  byte_length = 2
}

locals {
  gateway_config = {
    backend_address_pool_name      = "agw-test-beap"
    frontend_port_name             = "agw-test-feport"
    frontend_ip_configuration_name = "agw-test-feip"
    http_setting_name              = "agw-test-be-htst"
    listener_name                  = "agw-test-httplstn"
    request_routing_rule_name      = "agw-test-rqrt"
    redirect_configuration_name    = "agw-test-rdrcfg"
    frontend_ip                    = "10.20.6.5"
    gateway_name                   = "agw-${var.team}-${var.tenant}"
    domain_name_label              = "agw-${var.team}-${var.tenant}-001-${random_id.agw.hex}"
  }
}

## give the Public IP a DNS registration in the form of 
##      <appgwname>-<LZ-instancenumber>-<randomword>.<location>.cloudapp.azure.com
## example: agw-test-nonprod-weu-001-f765.westeurope.cloudapp.azure.com
resource "azurerm_public_ip" "spoke" {
  name                = "pip-appgtw-test"
  resource_group_name = azurerm_resource_group.agw-rg.name
  location            = azurerm_resource_group.agw-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  #   domain_name_label   = local.gateway_config.domain_name_label
}

resource "azurerm_user_assigned_identity" "appgw_id" {
  resource_group_name = azurerm_resource_group.agw-rg.name
  location            = azurerm_resource_group.agw-rg.location
  name                = "appgw-id-test"

}

resource "azurerm_application_gateway" "spoke" {
  count               = var.status == "create" ? 1 : 0
  name                = local.gateway_config.gateway_name
  resource_group_name = azurerm_resource_group.agw-rg.name
  location            = azurerm_resource_group.agw-rg.location
  zones               = ["1", "2", "3"]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw_id.id]
  }

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites = [
      "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    ]

  }

  waf_configuration {
    enabled            = true
    firewall_mode      = "Detection"
    rule_set_type      = "OWASP"
    rule_set_version   = "3.2"
    request_body_check = false
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 20
  }

  gateway_ip_configuration {
    name      = "gwipconfig"
    subnet_id = azurerm_subnet.subnets["agw"].id
  }

  frontend_port {
    name = local.gateway_config.frontend_port_name
    port = 80
  }

  # https://stackoverflow.com/questions/62227567/terraform-azure-unable-to-create-private-ip-configuration-for-application-gatewa
  # https://azure.github.io/application-gateway-kubernetes-ingress/features/private-ip/

  frontend_ip_configuration {
    name                          = "${local.gateway_config.frontend_ip_configuration_name}private"
    subnet_id                     = azurerm_subnet.subnets["agw"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = local.gateway_config.frontend_ip
  }

  frontend_ip_configuration {
    name                 = local.gateway_config.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.spoke.id
  }

  backend_address_pool {
    name = local.gateway_config.backend_address_pool_name
    # fqdns = [azurerm_app_service.main.default_site_hostname]
  }

  backend_http_settings {
    name                                = local.gateway_config.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
    # probe_name                          = "appsvc-probe"
  }

  http_listener {
    name                           = local.gateway_config.listener_name
    frontend_ip_configuration_name = "${local.gateway_config.frontend_ip_configuration_name}private"
    frontend_port_name             = local.gateway_config.frontend_port_name
    protocol                       = "Http"
    host_name                      = "appsvc.domain.local"
    # ssl_certificate_name           = "cert1"
  }

  request_routing_rule {
    name                       = local.gateway_config.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.gateway_config.listener_name
    backend_address_pool_name  = local.gateway_config.backend_address_pool_name
    backend_http_settings_name = local.gateway_config.http_setting_name
    priority                   = 10
  }

  lifecycle {
    ignore_changes = [
      tags["managed-by-k8s-ingress"],
      tags["costsaving"],
      ssl_certificate,
      frontend_port,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      url_path_map,
      waf_configuration,
      rewrite_rule_set
    ]
  }
}




# resource "azurerm_role_assignment" "deployment_group_on_agw" {
#   role_definition_name = "Contributor"
#   principal_id         = data.azuread_group.deploymnent_identities.object_id
#   scope                = azurerm_application_gateway.spoke.id
# }

# resource "azurerm_role_assignment" "deployment_group_on_agw_identity" {
#   role_definition_name = "Managed Identity Operator"
#   principal_id         = data.azuread_group.deploymnent_identities.object_id
#   scope                = azurerm_user_assigned_identity.appgw_id.id
# }
