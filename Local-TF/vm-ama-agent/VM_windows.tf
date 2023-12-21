variable "prefix_windows" {
  default = "ama-windows"
}

locals {
  vm_name_windows = "${var.prefix_windows}-vm"
}

resource "azurerm_public_ip" "windows" {
  name                = "${var.prefix_windows}-pip"
  resource_group_name = azurerm_resource_group.vm_ama.name
  location            = azurerm_resource_group.vm_ama.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_network_interface" "windows" {
  name                = "${var.prefix_windows}-nic"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_ama.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }
}

resource "azurerm_network_security_group" "windows" {
  name                = "windows-nsg"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name
}

resource "azurerm_network_security_rule" "windows" {
  name                        = "RDP"
  priority                    = 3389
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vm_ama.name
  network_security_group_name = azurerm_network_security_group.windows.name
}

resource "azurerm_subnet_network_security_group_association" "windows" {
  subnet_id                 = azurerm_subnet.vm_ama.id
  network_security_group_id = azurerm_network_security_group.windows.id
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                  = local.vm_name_windows
  location              = azurerm_resource_group.vm_ama.location
  resource_group_name   = azurerm_resource_group.vm_ama.name
  network_interface_ids = [azurerm_network_interface.windows.id]
  size                  = "Standard_D2s_v5"
  computer_name         = local.vm_name_windows
  admin_username        = "testadmin"
  admin_password        = "PASSWORDVM"
  zone                  = 1

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "windows" {
  name                 = "${local.vm_name_windows}-disk"
  location             = azurerm_resource_group.vm_ama.location
  resource_group_name  = azurerm_resource_group.vm_ama.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 50
  zone                 = "1"

}

resource "azurerm_virtual_machine_data_disk_attachment" "windows" {
  managed_disk_id    = azurerm_managed_disk.windows.id
  virtual_machine_id = azurerm_windows_virtual_machine.windows.id
  lun                = "0"
  caching            = "None"
}
