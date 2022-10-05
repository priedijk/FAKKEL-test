
resource "azurerm_resource_group" "hub" {
  name     = "rg-hub${random_id.nr.hex}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub${random_id.nr.hex}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "hub" {
  name                                           = "hub-subnet"
  resource_group_name                            = azurerm_resource_group.hub.name
  virtual_network_name                           = azurerm_virtual_network.hub.name
  address_prefixes                               = ["10.0.0.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = false
}


resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.hub.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet" "hubfw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "fwpip" {
  name                = "fw001pip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
  name                = "fw001"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hubfw.id
    public_ip_address_id = azurerm_public_ip.fwpip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "aks1" {
  name                = "aks1"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "udp-1194"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "1194",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "UDP",
    ]
  }

  rule {
    name = "udp-53"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "53",
    ]
    destination_addresses = [
      "*",
    ]
    protocols = [
      "UDP",
    ]
  }

  rule {
    name = "tcp-9000"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "9000",
    ]
    destination_addresses = [
      "*",
    ]
    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "udp-123"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "123",
    ]
    destination_addresses = [
      "*",
    ]
    protocols = [
      "UDP",
    ]
  }

  rule {
    name = "vm-any"
    source_addresses = [
      "${azurerm_network_interface.hub.private_ip_address}",
    ]
    destination_ports = [
      "*",
    ]
    destination_addresses = [
      "*",
    ]
    protocols = [
      "Any",
    ]
  }

  rule {
    name = "any-any"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "*",
    ]
    destination_addresses = [
      "*",
    ]
    protocols = [
      "Any",
    ]
  }
}

resource "azurerm_firewall_application_rule_collection" "aks1" {
  name                = "aks1"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "aks1"

    source_addresses = [
      "*",
    ]

    #       "*.hcp.westeurope.azmk8s.io",
    target_fqdns = [
      "mcr.microsoft.com",
      "*.data.mcr.microsoft.com",
      "management.azure.com",
      "login.microsoftonline.com",
      "packages.microsoft.com",
      "acs-mirror.azureedge.net",
      "login.microsoftonline.com",
      "*.ods.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.monitoring.azure.com",
      "dc.services.visualstudio.com",
      "data.policy.core.windows.net",
      "store.policy.core.windows.net",
      "dc.services.visualstudio.com",
      "westeurope.dp.kubernetesconfiguration.azure.com",
      "raw.githubusercontent.com",
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "aks2"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "security.ubuntu.com",
      "azure.archive.ubuntu.com",
      "changelogs.ubuntu.com",
    ]

    protocol {
      port = "80"
      type = "Http"
    }
  }
}

# ServiceTag - AzureMonitor:443 	TCP 	443 	This endpoint is used to send metrics data and logs to Azure Monitor and Log Analytics.

# az aks command invoke -n $AKS -g $RG -c 'helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts && helm repo update && helm upgrade --install aad-pod-identity aad-pod-identity/aad-pod-identity --namespace=kube-system'
# (KubernetesOperationError) Failed to run command in managed cluster due to kubernetes failure. details: Get "https://20.54.138.2:443/api/v1/namespaces/aks-command/pods/command-b8d04316b627430bb29b4314ee019124": net/http: TLS handshake timeout
# Code: KubernetesOperationError
# Message: Failed to run command in managed cluster due to kubernetes failure. details: Get "https://20.54.138.2:443/api/v1/namespaces/aks-command/pods/command-b8d04316b627430bb29b4314ee019124": net/http: TLS handshake timeout


























resource "azurerm_route_table" "main" {
  name                = "main"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  route {
    name                   = "main"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }

  # route {
  #   name                   = "main1"
  #   address_prefix         = "0.0.0.0/1"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  # }

  # route {
  #   name                   = "main2"
  #   address_prefix         = "128.0.0.0/1"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  # }

  route {
    name           = "azure"
    address_prefix = "AzureCloud"
    next_hop_type  = "Internet"
  }

  route {
    name           = "tedprivateip"
    address_prefix = "83.84.210.79/32"
    next_hop_type  = "Internet"
  }

  route {
    name           = "tedprivateip2"
    address_prefix = "109.38.151.48/32"
    next_hop_type  = "Internet"
  }



}

resource "azurerm_private_dns_zone" "hubappsvc" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone" "hubaks" {
  name                = "privatelink.westeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone" "hubacr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone" "hubakv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-acrdns" {
  name                  = "hub-acrdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubacr.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-aksdns" {
  name                  = "hub-aksdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubaks.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-akvdns" {
  name                  = "hub-akvdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubakv.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub-appsvcdns" {
  name                  = "hub-appsvcdns"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = azurerm_private_dns_zone.hubappsvc.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_virtual_network_peering" "hub2spoke" {
  name                      = "hub2spoke"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}
