[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $subscription,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant
)

echo ${subscription}
echo $location
echo $tenant

#terraform import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"
#terraform import azurerm_virtual_network.import-vnet "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet"
terraform import azurerm_subnet.subnets['\"firewall\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/AzureFirewallSubnet"
terraform import azurerm_subnet.subnets['\"gateway\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-${location}/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/GatewaySubnet"