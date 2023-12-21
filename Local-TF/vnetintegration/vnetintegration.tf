# app svc 1

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id = azurerm_app_service.appservice.id
  subnet_id      = azurerm_subnet.delegated.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "vnetintegrationconnection" {
  slot_name      = azurerm_app_service_slot.appservice_slot.name
  app_service_id = azurerm_app_service.appservice.id
  subnet_id      = azurerm_subnet.delegated.id
}

# app svc 2
resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection2" {
  app_service_id = azurerm_app_service.appservice2.id
  subnet_id      = azurerm_subnet.delegated2.id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "vnetintegrationconnection2" {
  slot_name      = azurerm_app_service_slot.appservice_slot2.name
  app_service_id = azurerm_app_service.appservice2.id
  subnet_id      = azurerm_subnet.delegated2.id
}
