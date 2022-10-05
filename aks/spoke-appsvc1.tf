
# https://docs.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview#impact-of-subnet-delegation-on-your-subnet
# https://docs.microsoft.com/en-us/azure/app-service/networking/private-endpoint
# https://docs.microsoft.com/en-us/azure/app-service/scripts/terraform-secure-backend-frontend

resource "random_id" "appname" {
  byte_length = 4
}

resource "azurerm_service_plan" "first" {
  name                  = "first-appserviceplan"
  location              = azurerm_resource_group.spoke.location
  resource_group_name   = azurerm_resource_group.spoke.name
  zone_balancing_enable = true
  os_type               = "Linux"
  sku_name              = "P1v3"
  reserved              = true

}


resource "azurerm_app_service" "main1" {
  name                = "appsvc1-${random_id.appname.hex}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  app_service_plan_id = azurerm_service_plan.first.id
  identity {
    type = "SystemAssigned"
  }
  site_config {
    vnet_route_all_enabled = true
    linux_fx_version       = "DOCKER|tvdvoorde/php5000:2"
    ftps_state             = "FtpsOnly"
  }

  #linux_fx_version = "PHP|7.4"


  app_settings = {
    "WEBSITE_DNS_SERVER" = "168.63.129.16",
    "environment"        = "prod"
    "SECRETFROMKEYVAULT" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mysecret.id})"
  }

  logs {
    application_logs {
      file_system_level = "Error"
    }
    http_logs {
      file_system {
        retention_in_days = 30
        retention_in_mb   = 35
      }
    }
  }
}




resource "azurerm_monitor_diagnostic_setting" "main1" {
  name                       = "${azurerm_app_service.main1.name}-DIAGNOSTIC"
  target_resource_id         = azurerm_app_service.main1.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub.id

  log {
    category = "AppServiceAppLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AppServiceAntivirusScanAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }


  log {
    category = "AppServiceFileAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }


  log {
    category = "AppServiceAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }


  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }


  log {
    category = "AppServicePlatformLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }


  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

















resource "azurerm_app_service_slot" "staging" {
  name                = "staging"
  app_service_name    = azurerm_app_service.main1.name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  app_service_plan_id = azurerm_service_plan.first.id

  site_config {
    vnet_route_all_enabled = true
    linux_fx_version       = "DOCKER|tvdvoorde/php5000:2"
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" = "168.63.129.16",
    "environment"        = "staging"
    "SECRETFROMKEYVAULT" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.mysecret.id})"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection1a" {
  app_service_id = azurerm_app_service.main1.id
  subnet_id      = azurerm_subnet.spoke1int.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "vnetintegrationconnection1b" {
  slot_name      = azurerm_app_service_slot.staging.name
  app_service_id = azurerm_app_service.main1.id
  subnet_id      = azurerm_subnet.spoke1int.id
}

resource "azurerm_private_endpoint" "privateendpoint" {
  name                = "webappprivateendpoint"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = azurerm_subnet.spoke1end.id
  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.hubappsvc.id]
  }
  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_app_service.main1.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "privateendpoint-slot" {
  name                = "webappprivateendpoint-slot"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = azurerm_subnet.spoke1end.id
  private_dns_zone_group {
    name                 = "privatednszonegroup-slot"
    private_dns_zone_ids = [azurerm_private_dns_zone.hubappsvc.id]
  }
  private_service_connection {
    name                           = "privateendpointconnection-slot"
    private_connection_resource_id = azurerm_app_service.main1.id
    subresource_names              = ["sites-staging"]
    is_manual_connection           = false
  }
  depends_on = [
    azurerm_private_endpoint.privateendpoint,
  ]
}

resource "azurerm_key_vault_access_policy" "appsvc" {
  key_vault_id = azurerm_key_vault.spoke.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.main1.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
  depends_on = [
    azurerm_key_vault.spoke,
    azurerm_app_service.main1
  ]
}


resource "azurerm_application_insights" "spoke" {
  name                = "spoke-appinsights"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  application_type    = "java"
  # Node.JS (Node.js)
  # other (General)
  # web (ASP.NET)
}

# az group create --name ContosoAppInsightRG --location eastus2
# az monitor log-analytics workspace create --resource-group ContosoAppInsightRG \
#    --workspace-name AppInWorkspace

# az monitor app-insights component create --resource-group ContosoAppInsightRG \
#    --app ContosoApp --location eastus2 --kind web --application-type web \
#    --retention-time 120
# az monitor app-insights component show --resource-group ContosoAppInsightRG --app ContosoApp

# az appservice plan create --resource-group ContosoAppInsightRG --name ContosoAppService
# az webapp create --resource-group ContosoAppInsightRG --name ContosoApp \
#    --plan ContosoAppService --name ContosoApp8765

# az monitor app-insights component connect-webapp --resource-group rg-spoke67e5b28a \
#     --app spoke-appinsights --web-app appsvc1-d033990f --enable-debugger false --enable-profiler false



# [
#   {
#     "name": "WEBSITE_DNS_SERVER",
#     "slotSetting": false,        
#     "value": "168.63.129.16"
#   },
#   {
#     "name": "environment",
#     "slotSetting": false,
#     "value": "prod"
#   },
#   {
#     "name": "WEBSITE_HTTPLOGGING_RETENTION_DAYS",
#     "slotSetting": false,
#     "value": "30"
#   },
#   {
#     "name": "APPINSIGHTS_INSTRUMENTATIONKEY",
#     "slotSetting": false,
#     "value": "02de3bc7-e460-43f9-b82c-af0e970e90e7"
#   },
#   {
#     "name": "APPINSIGHTS_PROFILERFEATURE_VERSION",
#     "slotSetting": false,
#     "value": "disabled"
#   },
#   {
#     "name": "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
#     "slotSetting": false,
#     "value": "disabled"
#   },
#   {
#     "name": "SECRETFROMKEYVAULT",
#     "slotSetting": false,
#     "value": "@Microsoft.KeyVault(SecretUri=https://keyvaulte2e2071f.vault.azure.net/secrets/MYSECRET/5480cfe0d07d49afaec70fc84ec4584b)"
#   }
# ]
