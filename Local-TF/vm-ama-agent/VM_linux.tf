variable "prefix_linux" {
  default = "vm-ama-linux"
}

locals {
  vm_name_linux = "${var.prefix_linux}-vm"
}


resource "azurerm_public_ip" "linux" {
  name                = "${var.prefix_linux}-pip"
  resource_group_name = azurerm_resource_group.vm_ama.name
  location            = azurerm_resource_group.vm_ama.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_network_interface" "linux" {
  name                = "${var.prefix_linux}-nic"
  location            = azurerm_resource_group.vm_ama.location
  resource_group_name = azurerm_resource_group.vm_ama.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_ama.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux.id
  }
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                            = local.vm_name_linux
  location                        = azurerm_resource_group.vm_ama.location
  resource_group_name             = azurerm_resource_group.vm_ama.name
  network_interface_ids           = [azurerm_network_interface.linux.id]
  size                            = "Standard_D2s_v5"
  computer_name                   = local.vm_name_linux
  disable_password_authentication = false
  admin_username                  = "testadmin"
  admin_password                  = "PASSWORDVM"
  zone                            = 1

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm.id]
  }

  additional_capabilities {
    ultra_ssd_enabled = true
  }


  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
    # publisher = "Canonical"
    # offer     = "UbuntuServer"
    # sku       = "16.04-LTS"
    # version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_managed_disk" "linux" {
  name                 = "${local.vm_name_linux}-disk"
  location             = azurerm_resource_group.vm_ama.location
  resource_group_name  = azurerm_resource_group.vm_ama.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 50
  zone                 = "1"

}

resource "azurerm_virtual_machine_data_disk_attachment" "linux" {
  managed_disk_id    = azurerm_managed_disk.linux.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux.id
  lun                = "0"
  caching            = "None"
}
