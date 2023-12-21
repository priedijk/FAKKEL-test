variable "prefix" {
  default = "cmkdisk"
}

locals {
  vm_name = "${var.prefix}-vm"
  disk2   = "false"
}

resource "azurerm_virtual_network" "disks" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.disks.location
  resource_group_name = azurerm_resource_group.disks.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.disks.name
  virtual_network_name = azurerm_virtual_network.disks.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "disks" {
  name                = "${var.prefix}-pip1"
  resource_group_name = azurerm_resource_group.disks.name
  location            = azurerm_resource_group.disks.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "disks" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.disks.location
  resource_group_name = azurerm_resource_group.disks.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.disks.id
  }
}

resource "azurerm_virtual_machine" "disks" {
  name                             = local.vm_name
  location                         = azurerm_resource_group.disks.location
  resource_group_name              = azurerm_resource_group.disks.name
  network_interface_ids            = [azurerm_network_interface.disks.id]
  vm_size                          = "Standard_DS2_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = local.vm_name
    admin_username = "testadmin"
    admin_password = "PASSWORDVM"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_managed_disk" "disk1" {
  name                   = "${local.vm_name}-disk1"
  location               = azurerm_resource_group.disks.location
  resource_group_name    = azurerm_resource_group.disks.name
  storage_account_type   = "Standard_LRS"
  create_option          = "Empty"
  disk_size_gb           = 50
  disk_encryption_set_id = lower(var.secret_data) ? azurerm_disk_encryption_set.des.0.id : null

  depends_on = [
    azurerm_disk_encryption_set.des,
    azurerm_key_vault_access_policy.des_access_policy
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk1" {
  managed_disk_id    = azurerm_managed_disk.disk1.id
  virtual_machine_id = azurerm_virtual_machine.disks.id
  lun                = "0"
  caching            = "ReadWrite"
}

# resource "azurerm_managed_disk" "disk2" {
#   count                = local.disk2 == "true" && var.location_code == "weu" ? 1 : 0
#   name                 = "${local.vm_name}-disk2"
#   location             = azurerm_resource_group.disks.location
#   resource_group_name  = azurerm_resource_group.disks.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 10
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "disk2" {
#   count              = local.disk2 == "true" && var.location_code == "weu" ? 1 : 0
#   managed_disk_id    = azurerm_managed_disk.disk2[0].id
#   virtual_machine_id = azurerm_virtual_machine.disks.id
#   lun                = "1"
#   caching            = "ReadWrite"
# }

resource "azurerm_network_security_group" "disks" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.disks.location
  resource_group_name = azurerm_resource_group.disks.name

  security_rule {
    name                       = "SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = ["80.114.81.41", "84.104.239.28", "213.208.251.210", "109.69.228.221", ]
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "disks" {
  network_interface_id      = azurerm_network_interface.disks.id
  network_security_group_id = azurerm_network_security_group.disks.id
}
