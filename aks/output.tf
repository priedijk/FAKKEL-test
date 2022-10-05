output "resourcegroup" {
  value = azurerm_resource_group.spoke.name
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.app.client_id
}

output "identity_tenant_id" {
  value = azurerm_user_assigned_identity.app.tenant_id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.app.principal_id
}

output "identity_id" {
  value = azurerm_user_assigned_identity.app.id
}

output "keyvault_name" {
  value = azurerm_key_vault.spoke.name
}

output "id_name" {
  value = azurerm_user_assigned_identity.app.name
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "agw_name" {
  value = azurerm_application_gateway.spoke.name
}

output "agw_resource_group" {
  value = azurerm_application_gateway.spoke.resource_group_name
}

output "agic_client_id" {
  value = azurerm_user_assigned_identity.agic-id.client_id
}

output "agic_tenant_id" {
  value = azurerm_user_assigned_identity.agic-id.tenant_id
}

output "agic_id" {
  value = azurerm_user_assigned_identity.agic-id.id
}

output "appsvc_hostname" {
  value = azurerm_app_service.main1.default_site_hostname
}

output "vm" {
  value = "${azurerm_public_ip.hub.domain_name_label}.westeurope.cloudapp.azure.com"
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_resource_group_name" {
  value = azurerm_kubernetes_cluster.aks.resource_group_name
}