terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"privatelink.api.azureml.ms\"'] "/subscriptions/${subscription}/resourceGroups/rg-privatedns-hub-${location}-001/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"privatelink.azuresynapse.net\"'] "/subscriptions/${subscription}/resourceGroups/rg-privatedns-hub-${location}-001/providers/Microsoft.Network/privateDnsZones/privatelink.azuresynapse.net"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"privatelink.dfs.core.windows.net\"'] "/subscriptions/${subscription}/resourceGroups/rg-privatedns-hub-${location}-001/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"privatelink.queue.core.windows.net\"'] "/subscriptions/${subscription}/resourceGroups/rg-privatedns-hub-${location}-001/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"

privatelink.api.azureml.ms
privatelink.azuresynapse.net
privatelink.dfs.core.windows.net
privatelink.queue.core.windows.net

terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"
terraform -chdir="${terraformdir}" import azurerm_private_dns_zone.hub['\"

\"'] "/subscriptions/${subscription}/resourceGroups/rg-privatedns-hub-${location}-001/providers/Microsoft.Network/privateDnsZones/