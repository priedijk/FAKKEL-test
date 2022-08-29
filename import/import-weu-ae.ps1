#echo $(ARM_SUBSCRIPTION_ID)
echo "$(ARM_SUBSCRIPTION_ID)"

#terraform import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"
#terraform import azurerm_virtual_network.import-vnet "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet"
terraform import azurerm_subnet.subnets['\"firewall\"'] "/subscriptions/"$(ARM_SUBSCRIPTION_ID)"/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/AzureFirewallSubnet"
terraform import azurerm_subnet.subnets['\"gateway\"'] "/subscriptions/"$(ARM_SUBSCRIPTION_ID)"/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/GatewaySubnet"