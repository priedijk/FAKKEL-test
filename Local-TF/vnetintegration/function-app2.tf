resource "azurerm_storage_account" "example2" {
  name                     = "fsacsc04201222222"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "example2" {
  name                       = "fsacsc04201222222"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.terraform2.id
  storage_account_name       = azurerm_storage_account.example2.name
  storage_account_access_key = azurerm_storage_account.example2.primary_access_key
}

resource "azurerm_app_service_virtual_network_swift_connection" "example2" {
  app_service_id = azurerm_function_app.example2.id
  subnet_id      = azurerm_subnet.delegated2.id
}
