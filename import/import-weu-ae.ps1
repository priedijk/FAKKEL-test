[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $subscription,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $terraformdir
)

#$import="terraform -chdir=${terraformdir} import"
$terraformdir="../vnet-import"

#& $import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"
& terraform -chdir=${terraformdir} import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"

& terraform import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"

& terraform import azurerm_virtual_network.import-vnet "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet"

& terraform import azurerm_subnet.subnets['\"AzureFirewallSubnet\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/AzureFirewallSubnet"
& terraform import azurerm_subnet.subnets['\"GatewaySubnet\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/GatewaySubnet"
& terraform import azurerm_subnet.subnets['\"troep\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/troep"


& terraform import azurerm_network_security_group.nsg['\"apim\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_ap_weu"
& terraform import azurerm_network_security_group.nsg['\"apim_ingress\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_api_weu"
& terraform import azurerm_network_security_group.nsg['\"weballow\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_web_weu"

& terraform import azurerm_network_security_rule.nsg_rules_bastion2  "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_web_weu/securityRules/portranges"

& terraform import azurerm_subnet_network_security_group_association.assoc['\"troep\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/troep"