data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}


resource "azurerm_automation_account" "spoke" {
  name                = "foundation2servicecatalogue"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  sku_name = "Basic"
}

resource "azurerm_automation_variable_string" "kvname" {
  name                    = "kvname"
  resource_group_name     = azurerm_resource_group.spoke.name
  automation_account_name = azurerm_automation_account.spoke.name
  value                   = azurerm_key_vault.spoke.name
}



data "azurerm_automation_variable_string" "example" {
  name                    = "tfex-example-var"
  resource_group_name     = "tfex-example-rg"
  automation_account_name = "foundation2servicecatalogue"
}

output "var1" {
  value = data.azurerm_automation_variable_string.example.id
}



resource "azurerm_key_vault" "spoke" {
  name                        = "keyvault${random_id.name.hex}"
  location                    = azurerm_resource_group.spoke.location
  resource_group_name         = azurerm_resource_group.spoke.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

resource "azurerm_key_vault_secret" "mysecret" {
  name         = "MYSECRET"
  value        = "MYSECRETVALUE"
  key_vault_id = azurerm_key_vault.spoke.id
  depends_on = [
    azurerm_key_vault_access_policy.admin,
  ]
}

resource "azurerm_key_vault_access_policy" "admin" {
  key_vault_id = azurerm_key_vault.spoke.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  # object_id    = data.azurerm_client_config.current.object_id
  object_id    = data.azuread_client_config.current.object_id
  key_permissions = [
    "Get",
    "Create",
    "Update",
    "Delete",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Get",
    "Create",
    "Update",
    "Delete",
    "Import",
    "List",
    "Recover",
    "Backup",
    "Restore",
    "Purge",
  ]
}

resource "azurerm_private_endpoint" "akvprivateendpoint" {
  name                = "akvprivateendpoint"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = azurerm_subnet.data.id
  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.hubakv.id]
  }
  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_key_vault.spoke.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

resource "azurerm_key_vault_certificate" "cert1" {
  name         = "generated-cert"
  key_vault_id = azurerm_key_vault.spoke.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["appsvc.domain.local", "www.appsvc.domain.local"]
      }

      subject            = "CN=appsvc"
      validity_in_months = 12
    }
  }
  depends_on = [
    azurerm_key_vault_access_policy.admin,
  ]
}