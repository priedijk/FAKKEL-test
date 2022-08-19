locals {
    vnet_address_space = "${lookup(var.vnet_address_space, "${var.location}_${var.tenant}").address_space}"
    subnet_env_name    = "var.network_${var.location}_${var.tenant}"
    /*
    subnet_env         = "${lookup(local.subnet_env_name)}"
    */
}
/*
resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.weu.address_space]
}
*/
resource "azurerm_virtual_network" "import-vnet" {
  name                = "import-vnet"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [local.vnet_address_space]
}

  
/*
resource "azurerm_virtual_network" "import-vnet1" {
  name                = "import-vnet1"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.weu.value.address_space]
}

resource "azurerm_virtual_network" "import-vnet2" {
  name                = "import-vnet2"
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  address_space       = [var.vnet_address_space.value.weu.address_space]
}
*/
resource "azurerm_subnet" "subnets" {
  for_each             = var.network_weu_ae
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = azurerm_virtual_network.import-vnet.name
  address_prefixes     = [each.value.subnet_address]
}

output "test" {
  value = local.subnet_env_name 
}

output "test2" {
  value = local.subnet_env_name 
}