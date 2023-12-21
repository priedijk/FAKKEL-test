resource "azurerm_app_service" "appservice2" {

  name                = var.app_service_name2
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.terraform2.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  client_affinity_enabled = false
  client_cert_enabled     = false
  https_only              = true

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

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config.0.health_check_path,
      client_affinity_enabled
    ]
  }
}


#------App-Service-Slot--------#

resource "azurerm_app_service_slot" "appservice_slot2" {
  name                = "staging"
  app_service_name    = azurerm_app_service.appservice2.name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.terraform2.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  client_affinity_enabled = false
  https_only              = true

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

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config.0.health_check_path,
      client_affinity_enabled
    ]
  }
}

resource "azurerm_private_endpoint" "privateendpoint2" {
  name                = join("-", [var.app_service_name2, "endpoint"])
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = join("-", [var.app_service_name2, "pv-connection"])
    private_connection_resource_id = azurerm_app_service.appservice2.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "privateendpoint_slot2" {
  name                = join("-", [var.app_service_name2, "slot-endpoint"])
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = join("-", [var.app_service_name2, "pv-connection"])
    private_connection_resource_id = azurerm_app_service.appservice2.id
    subresource_names              = ["sites-staging"]
    is_manual_connection           = false
  }
}
