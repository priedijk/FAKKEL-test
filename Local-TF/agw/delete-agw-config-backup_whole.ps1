param(
    # [String]  [Parameter (Mandatory = $true)]  $aksClusterInstance,
    [String]  [Parameter (Mandatory = $true)]  $location,
    [String]  [Parameter (Mandatory = $true)]  $domain
    # [bool]    [Parameter (Mandatory = $true)]  $publicCa,
    # [bool]    [Parameter (Mandatory = $true)]  $publicIp,
    # [String]  [Parameter (Mandatory = $true)]  $priority,
    # [String]  [Parameter (Mandatory = $true)]  $healthProbe,
    # [String]  [Parameter (Mandatory = $true)]  $listenerAltNames,
    # [String]  [Parameter (Mandatory = $true)]  $backendHostNameOverride,
    # [String]  [Parameter (Mandatory = $true)]  $backendRootCertificate
)

$ErrorActionPreference = 'Stop'

# validations
# if (-not ($aksClusterInstance -eq '01' -or $aksClusterInstance -eq '02')) {
#     Write-Error "ERROR aks-cluster input must be either '01' or '02'"
# }

if (-not ($location -eq 'frc' -or $location -eq 'weu')) {
    Write-Error "ERROR location input must be either 'frc' or 'weu'"
}


# # discover aks 
# $aksResourceGroup = az group list --query "[?tags.logicalname == 'rg-aks$($aksClusterInstance)' && tags.location == '$location']" | ConvertFrom-Json
# $aksCluster = az aks list --resource-group $aksResourceGroup.name | ConvertFrom-Json
# if (-not $aksCluster) {
#     Write-Error "ERROR Failed to discover the AKS cluster to use."
# }
# $aksLoadBalancer = az network lb  show --name kubernetes-internal --resource-group "MC_$($aksCluster.name)" | ConvertFrom-Json
# $aksloadBalancerPrivateIp = $aksLoadBalancer.frontendIpConfigurations[0].privateIpAddress

# discover agw 
$agw = az network application-gateway list --query "[?tags.location == '$($location)']" | ConvertFrom-Json
if (-not $agw) {
    Write-Error "ERROR Failed to discover application gateway to use."
}
# foreach ($frontendIpConfiguration in $agw.frontendIPConfigurations) {
#     if ($frontendIpConfiguration.PrivateIPAddress) {
#         $privateIpName = $frontendIpConfiguration.name
#     }
#     else {
#         $publicIpName = $frontendIpConfiguration.name
#     }
# } 
# if ($publicIp) {
#     $frontendIpName = $publicIpName
#     $port = 8443
# }
# else {
#     $frontendIpName = $privateIpName 
#     $port = 443
# }

# # discover certificate
# $keyvault = az keyvault list --query "[?tags.location == '$($location)' && tags.logicalname == 'keyvault-app']" | ConvertFrom-Json
# if (-not $keyvault) {
#     Write-Error "ERROR Failed to discover keyvault to use."
# }
# if ($publicCa) {
#     $certificate = az keyvault certificate list --vault-name $keyvault.name --query "[?tags.domain == '$($domain)' && ends_with(name, 'pub-ca')]" | ConvertFrom-Json
# }
# else {
#     $certificate = az keyvault certificate list --vault-name $keyvault.name  --query "[?tags.domain == '$($domain)' && ends_with(name, 'priv-ca')]" | ConvertFrom-Json
# }

# $backendHostName = ($backendHostNameOverride -eq 'none') ? "$($aksCluster.name).azure.dnscompany" : $backendHostNameOverride
# $listenerHostNames = ($listenerAltNames -eq 'none') ? $domain : "$($domain),$($listenerAltNames)".Split(',')

# $siteName = $domain.replace(".", "-dot-")

##
# Gathering information and deleting the resources #
##

# Rules
Write-Host "INFO gathering rules"
$agwRules = az network application-gateway rule list `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --query "[?starts_with(name, 'rule')].name" | ConvertFrom-Json

Write-Host "INFO deleting rules"

foreach ($rule in $agwRules) {
    
    Write-Host "Deleting rule $rule"

    az network application-gateway rule delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $rule
} 


# Backend settings
Write-Host "INFO gathering backend settings"
$agwBackendsettings = az network application-gateway http-settings list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'setting')].name" | ConvertFrom-Json

Write-Host "INFO deleting backend settings"

foreach ($backendSetting in $agwBackendsettings) {

    Write-Host "Deleting backend setting $backendSetting"

    az network application-gateway http-settings delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $backendSetting
}


# Health probes
Write-Host "INFO gathering health probes"
$agwProbes = az network application-gateway probe list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'probe')].name" | ConvertFrom-Json

Write-Host "INFO deleting health probes"

foreach ($probe in $agwProbes) {

    Write-Host "Deleting health probe $probe"

    az network application-gateway probe delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $probe
}

# Backend pools
Write-Host "INFO gathering backend pools"
$agwAddressPools = az network application-gateway address-pool list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'bepool')].name" | ConvertFrom-Json

Write-Host "INFO deleting backend pools"

foreach ($addressPool in $agwAddressPools) {

    Write-Host "Deleting backend pool $addressPool"

    az network application-gateway address-pool delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $addressPool
}


# HTTP listeners
Write-Host "INFO gathering HTTP listeners"
$agwHttpListeners = az network application-gateway http-listener list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'list')].name" | ConvertFrom-Json
  
Write-Host "INFO deleting HTTP listeners"

foreach ($httpListener in $agwHttpListeners) {

    Write-Host "Deleting HTTP listener $httpListener"

    az network application-gateway http-listener delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $httpListener
}


# SSL certificates
Write-Host "INFO gathering SSL certificates"
$agwSslCerts = az network application-gateway ssl-cert list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'cert')].name" | ConvertFrom-Json

Write-Host "INFO deleting SSL certificates"

foreach ($sslCert in $agwSslCerts) {

    Write-Host "Deleting SSL certificate $sslCert"

    az network application-gateway ssl-cert delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $sslCert
}

# Frontend ports
Write-Host "INFO gathering frontend ports"
$agwFrontendPorts = az network application-gateway frontend-port list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?starts_with(name, 'Port')].name" | ConvertFrom-Json

Write-Host "INFO deleting frontend ports"

foreach ($frontendPort in $agwFrontendPorts) {

    Write-Host "Deleting frontend port $frontendPort"

    az network application-gateway frontend-port delete `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name $frontendPort
}
