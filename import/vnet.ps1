[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $subscription,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $terraformdir
)


terraform -chdir="${terraformdir}" import azurerm_resource_group.vnet-rg "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test"

terraform -chdir="${terraformdir}" import azurerm_virtual_network.import-vnet "/subscriptions/e2c1b56d-a413-43fc-b1e2-f73e153c05ad/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet"

terraform -chdir="${terraformdir}" import azurerm_subnet.subnets['\"AzureFirewallSubnet\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/AzureFirewallSubnet"
terraform -chdir="${terraformdir}" import azurerm_subnet.subnets['\"GatewaySubnet\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/GatewaySubnet"
terraform -chdir="${terraformdir}" import azurerm_subnet.subnets['\"troep\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/troep"


terraform -chdir="${terraformdir}" import azurerm_network_security_group.nsg['\"apim\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_ap_weu"
terraform -chdir="${terraformdir}" import azurerm_network_security_group.nsg['\"apim_ingress\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_api_weu"
terraform -chdir="${terraformdir}" import azurerm_network_security_group.nsg['\"weballow\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_web_weu"

terraform -chdir="${terraformdir}" import azurerm_network_security_rule.nsg_rules_bastion2  "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/networkSecurityGroups/nsg_web_weu/securityRules/portranges"

terraform -chdir="${terraformdir}" import azurerm_subnet_network_security_group_association.assoc['\"troep\"'] "/subscriptions/${subscription}/resourceGroups/tf-import-test/providers/Microsoft.Network/virtualNetworks/import-vnet/subnets/troep"