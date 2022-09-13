resource "azurerm_route_table" "example" {
  name                = "example-routetable"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  route {
    name                   = "testtoure"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_subnet_route_table_association" "example" {
  for_each       = output.peering1
  subnet_id      = [each.value]
  route_table_id = azurerm_route_table.example.id
}
