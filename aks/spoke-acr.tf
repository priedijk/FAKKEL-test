resource "azurerm_container_registry" "acr" {
  name                = "acr${random_id.name.hex}"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  sku                 = "Premium"
  admin_enabled       = false

  # georeplications = [
  #   {
  #     location                = "westeurope"
  #     zone_redundancy_enabled = true
  #     tags                    = {}
  #     regional_endpoint_enabled = false
  #   },
  #   {
  #     location                = "francecentral"
  #     zone_redundancy_enabled = true
  #     tags                    = {}
  #     regional_endpoint_enabled = false
  # }]
}

resource "azurerm_role_assignment" "kubeletid_to_acr_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_private_endpoint" "acrprivateendpoint" {
  name                = "acrprivateendpoint"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = azurerm_subnet.data.id

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.hubacr.id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}
