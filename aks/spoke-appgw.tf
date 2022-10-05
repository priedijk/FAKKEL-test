
resource "azurerm_public_ip" "spoke" {
  name                = "spoke-pip"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.spoke.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.spoke.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.spoke.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.spoke.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.spoke.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.spoke.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.spoke.name}-rdrcfg"
}

# resource "azurerm_key_vault_certificate" "app2thx1139com" {
#   name         = "app2thx1139comcert"
#   key_vault_id = azurerm_key_vault.spoke.id

#   certificate {
#     contents = filebase64("app2.thx1139.com.pfx")
#     password = ""
#   }
#   depends_on = [
#     azurerm_key_vault_access_policy.admin,
#   ]
# }


resource "azurerm_key_vault_access_policy" "appgwkv" {
  key_vault_id = azurerm_key_vault.spoke.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw-id.principal_id

  key_permissions = [
    "Get", "List",
  ]

  secret_permissions = [
    "Get", "List",
  ]

  certificate_permissions = [
    "Get", "List",
  ]

  depends_on = [
    azurerm_key_vault.spoke,
  ]
}

resource "azurerm_user_assigned_identity" "appgw-id" {
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  name                = "appgw-id"
}

resource "azurerm_application_gateway" "spoke" {
  name                = "agw001"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw-id.id]
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gwipconfig"
    subnet_id = azurerm_subnet.agw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  # https://stackoverflow.com/questions/62227567/terraform-azure-unable-to-create-private-ip-configuration-for-application-gatewa
  # https://azure.github.io/application-gateway-kubernetes-ingress/features/private-ip/

  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}private"
    subnet_id                     = azurerm_subnet.agw.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.10"
  }

  ssl_certificate {
    name                = "cert1"
    key_vault_secret_id = azurerm_key_vault_certificate.cert1.secret_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.spoke.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [azurerm_app_service.main1.default_site_hostname]
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
    probe_name                          = "appsvc-probe"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}private"
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    host_name                      = "appsvc.domain.local"
    ssl_certificate_name           = "cert1"
  }

  probe {
    interval                                  = 10
    name                                      = "appsvc-probe"
    protocol                                  = "Https"
    path                                      = "/"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      body        = ""
      status_code = ["200-299"]
    }
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = "100"
  }
}

resource "azurerm_user_assigned_identity" "agic-id" {
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  location            = azurerm_resource_group.spoke.location
  name                = "agic-id"
}

resource "azurerm_role_assignment" "agic-contributor-appgw" {
  scope                = azurerm_application_gateway.spoke.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.agic-id.principal_id
}

resource "azurerm_role_assignment" "agic-reader-appgwgroup" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.spoke.name}"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.agic-id.principal_id
}

resource "azurerm_role_assignment" "agic-network-akssubnet" {
  #scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.spoke.name}"
  scope                = azurerm_virtual_network.spoke.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.agic-id.principal_id
}

resource "azurerm_role_assignment" "agic-mio-appgwgroup" {
  scope                = azurerm_user_assigned_identity.appgw-id.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.agic-id.principal_id
}