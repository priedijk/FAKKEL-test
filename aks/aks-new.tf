resource "azurerm_resource_group" "aks" {
  name     = "aks-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2"
  min_count             = 1
  max_count             = 2
  #availability_zones   = ["1", "2", "3"]
  vnet_subnet_id      = azurerm_subnet.userpool.id
  enable_auto_scaling = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "aks-test1"
  location                  = azurerm_resource_group.aks.location
  resource_group_name       = azurerm_resource_group.aks.name
  dns_prefix                = "aks-test1"
  automatic_channel_upgrade = "node-image"
  kubernetes_version        = "1.23.12"

  default_node_pool {
    name                         = "default"
    min_count                    = 1
    max_count                    = 3
    vm_size                      = "Standard_DS2_v2"
    vnet_subnet_id               = azurerm_subnet.systempool.id
    enable_auto_scaling          = true
    only_critical_addons_enabled = true
    #availability_zones          = ["1", "2", "3"]
  }

  azure_active_directory_role_based_access_control {
    managed = true
    # admin_group_object_ids = ["7ce4b940-3b71-4a60-a935-edec80b406b4"]
    azure_rbac_enabled = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    dns_service_ip     = "172.16.0.10"
    service_cidr       = "172.16.0.0/24"
    docker_bridge_cidr = "172.16.1.1/32"
  }

  tags = {
    builder = "pat"
  }
  lifecycle {
    ignore_changes = [
      key_vault_secrets_provider
    ]
  }

  depends_on = [
    azurerm_subnet_route_table_association.systempool,
    azurerm_subnet_route_table_association.userpool,
    azurerm_role_assignment.aks_contributor,
    azurerm_role_assignment.aks_network_contributor
  ]
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-identity"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_role_assignment" "aks_contributor" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
