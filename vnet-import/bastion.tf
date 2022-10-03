/*
resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bast-shared-hub-${var.location_code}-001"
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  sku                 = var.location_code == "weu" ? "Basic" : "Standard" 

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.subnet-test.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
*/
