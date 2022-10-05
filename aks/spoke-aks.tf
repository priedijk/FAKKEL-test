resource "random_id" "name" {
  byte_length = 4
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v5"
  min_count             = 1
  max_count             = 3
  #availability_zones   = ["1", "2", "3"]
  vnet_subnet_id      = azurerm_subnet.spoke.id
  enable_auto_scaling = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                                = "aks${random_id.name.hex}"
  location                            = azurerm_resource_group.spoke.location
  resource_group_name                 = azurerm_resource_group.spoke.name
  dns_prefix                          = "k8s${random_id.name.hex}"
  automatic_channel_upgrade           = "node-image"
  private_cluster_enabled             = true
  private_dns_zone_id                 = "None"
  private_cluster_public_fqdn_enabled = true
  kubernetes_version                  = "1.23"
  azure_policy_enabled                = true
  default_node_pool {
    name           = "default"
    min_count      = 1
    max_count      = 3
    vm_size        = "Standard_D4s_v5"
    vnet_subnet_id = azurerm_subnet.spoke.id
    #availability_zones  = ["1", "2", "3"]
    enable_auto_scaling = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.hub.id
  }

  azure_active_directory_role_based_access_control {
    managed = true
    # admin_group_object_ids = ["7ce4b940-3b71-4a60-a935-edec80b406b4"]
    azure_rbac_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "172.16.0.10"
    service_cidr       = "172.16.0.0/24"
    docker_bridge_cidr = "172.16.1.1/32"
  }

  tags = {
    builder = "ted"
  }
}

resource "azurerm_role_assignment" "kubeletid_mio_noderesourcegroup" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_kubernetes_cluster.aks.node_resource_group}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "kubeletid_vmc_noderesourcegroup" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_kubernetes_cluster.aks.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "kubeletid_mio_app" {
  #scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.spoke.name}"
  scope                = azurerm_user_assigned_identity.app.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_user_assigned_identity" "app" {
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  name                = "app-id"
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.spoke.id
  tenant_id    = azurerm_user_assigned_identity.app.tenant_id
  object_id    = azurerm_user_assigned_identity.app.principal_id
  secret_permissions = [
    "Get",
    "List"
  ]
}
