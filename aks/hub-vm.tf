resource "azurerm_network_interface" "hub" {
  name                = "hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.hub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hub.id
  }
}


resource "azurerm_public_ip" "hub" {
  name                = "publicip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Dynamic"
  domain_name_label   = "vm${random_id.nr.hex}"
}

resource "azurerm_virtual_machine" "hub" {
  name                  = "hub"
  location              = azurerm_resource_group.hub.location
  resource_group_name   = azurerm_resource_group.hub.name
  network_interface_ids = [azurerm_network_interface.hub.id]
  vm_size               = "Standard_B2ms"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  os_profile {
    computer_name  = "hub"
    admin_username = "azureuser"
    custom_data    = base64encode(file("install.sh"))
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwi0OVYEK31I/KCSa6z/vP/yx8XK02UkOIbaeDUoczWQaKCnNQ/V2ue5Bh94eSKGmAhxEVZd6dB3XigGhhUmov6jPfGZLBAeSHAbjBaFgryHBX/7uOasixKTpy8aegilAd3tELlc6+xpra0NTbtXfKz1yqcjUdciyDQCo7U5AXvl8NL5wggTtQk8jVR3VaV9ymtu7wvHRfIrvTp9aqQKN1q6Q9hnkYZwux7mRjdrkyZ5g8KonOYcUndVkYDgZmzdUcZrZL65y52eoP/Hl06Too2pjYmtaQ2qD4IOiFo6v7Kp6YdNfqWiEPkhgoicrwlaUmkiN4wXUQ1u/h17dklFQ2w== rsa-key-20190626"
    }
  }
}

# resource "azurerm_role_assignment" "vm-contributor" {
#   scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_virtual_machine.hub.identity[0].principal_id
# }

resource "azurerm_role_assignment" "vm-contributor-spoke" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.spoke.name}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_virtual_machine.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "vm-contributor-hub" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.hub.name}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_virtual_machine.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "user-cluster-admin" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.spoke.name}"
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_client_config.current.object_id
}