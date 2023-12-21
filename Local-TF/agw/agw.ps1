
# validations
if (-not ($aksClusterInstance -eq '01' -or $aksClusterInstance -eq '02')) {
    Write-Error "ERROR aks-cluster input must be either '01' or '02'"
}

if (-not ($location -eq 'frc' -or $location -eq 'weu')) {
    Write-Error "ERROR location input must be either 'frc' or 'weu'"
}


# discover aks 
$aksResourceGroup = az group list --query "[?tags.logicalname == 'rg-aks$($aksClusterInstance)' && tags.location == '$location']" | ConvertFrom-Json
$aksCluster = az aks list --resource-group $aksResourceGroup.name | ConvertFrom-Json
if (-not $aksCluster) {
    Write-Error "ERROR Failed to discover the AKS cluster to use."
}
$aksLoadBalancer = az network lb  show --name kubernetes-internal --resource-group "MC_$($aksCluster.name)" | ConvertFrom-Json
$aksloadBalancerPrivateIp = $aksLoadBalancer.frontendIpConfigurations[0].privateIpAddress

# discover agw 
$agw = az network application-gateway list --query "[?tags.location == '$($location)']" | ConvertFrom-Json
if (-not $agw) {
    Write-Error "ERROR Failed to discover application gateway to use."
}
foreach ($frontendIpConfiguration in $agw.frontendIPConfigurations) {
    if ($frontendIpConfiguration.PrivateIPAddress) {
        $privateIpName = $frontendIpConfiguration.name
    }
    else {
        $publicIpName = $frontendIpConfiguration.name
    }
} 
if ($publicIp) {
    $frontendIpName = $publicIpName
    $port = 8443
}
else {
    $frontendIpName = $privateIpName 
    $port = 443
}

# discover certificate
$keyvault = az keyvault list --query "[?tags.location == '$($location)' && tags.logicalname == 'keyvault-app']" | ConvertFrom-Json
if (-not $keyvault) {
    Write-Error "ERROR Failed to discover keyvault to use."
}
if ($publicCa) {
    $certificate = az keyvault certificate list --vault-name $keyvault.name --query "[?tags.domain == '$($domain)' && ends_with(name, 'pub-ca')]" | ConvertFrom-Json
}
else {
    $certificate = az keyvault certificate list --vault-name $keyvault.name  --query "[?tags.domain == '$($domain)' && ends_with(name, 'priv-ca')]" | ConvertFrom-Json
}

$backendHostName = ($backendHostNameOverride -eq 'none') ? "$($aksCluster.name).azure.dnscompany" : $backendHostNameOverride
$listenerHostNames = ($listenerAltNames -eq 'none') ? $domain : "$($domain),$($listenerAltNames)".Split(',')


# number 1
$agwresourceGroup = "agw-test"
$agwname = "agw-team-ae"
$port = "5000"
$siteName = "test-site-1"
$frontendIpName = "agw-test-feipprivate"
$listenerHostNames = "testlistenerhostname"
$serverIp = "10.20.6.65"
$healthProbe = "/healthz"
$backendHostName = "testserver"
$priority = 100

Write-Host "INFO create frontend port"
az network application-gateway frontend-port create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "Port_$($port)" `
    --port $port

Write-Host "INFO create ssl certificate"
az network application-gateway ssl-cert create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --cert-file "certs/mycert.pfx" `
    --cert-password "defh123" `
    --name cert-$siteName

Write-Host "INFO create http listener"
az network application-gateway http-listener create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --frontend-port "Port_$($port)" `
    --name list-$siteName `
    --frontend-ip $frontendIpName `
    --host-names $listenerHostNames `
    --ssl-cert cert-$siteName

Write-Host "INFO create address pool"
az network application-gateway address-pool create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "bepool1-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "probe1-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "setting1-$siteName" `
    --host-name $backendHostName `
    --probe "probe1-$siteName" `
    --protocol Https `
    --port 8443

Write-Host "INFO create rule"
az network application-gateway rule create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name rule-$siteName `
    --priority $priority `
    --address-pool bepool1-$siteName `
    --http-listener list-$siteName `
    --rule-type Basic `
    --http-settings setting1-$siteName

##    
#### cluster 2 for site 1
##
Write-Host "INFO create address pool"
az network application-gateway address-pool create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "bepool2-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "probe2-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "setting2-$siteName" `
    --host-name $backendHostName `
    --probe "probe2-$siteName" `
    --protocol Https `
    --port 8443



# Create number 2
# number 2
$agwresourceGroup = "agw-test"
$agwname = "agw-team-ae"
$port = "5000"
$siteName = "apple-site-2"
$frontendIpName = "agw-test-feipprivate"
$listenerHostNames = "testlistenerhostname2"
$serverIp = "10.20.6.80"
$healthProbe = "/2healthz2"
$backendHostName = "testserver2"
$priority = 120


Write-Host "INFO create ssl certificate"
az network application-gateway ssl-cert create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --cert-file "certs/mycert.pfx" `
    --cert-password "defh123" `
    --name cert-$siteName

Write-Host "INFO create http listener"
az network application-gateway http-listener create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --frontend-port "Port_$($port)" `
    --name list-$siteName `
    --frontend-ip $frontendIpName `
    --host-names $listenerHostNames `
    --ssl-cert cert-$siteName

Write-Host "INFO create address pool"
az network application-gateway address-pool create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "bepool1-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "probe1-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "setting1-$siteName" `
    --host-name $backendHostName `
    --probe "probe1-$siteName" `
    --protocol Https `
    --port 8443

Write-Host "INFO create rule"
az network application-gateway rule create `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name rule-$siteName `
    --priority $priority `
    --address-pool bepool1-$siteName `
    --http-listener list-$siteName `
    --rule-type Basic `
    --http-settings setting1-$siteName


















##
# Gathering information #
##

$agwRules = az network application-gateway rule list `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --query "[?starts_with(name, 'rule')].name" | ConvertFrom-Json

foreach ($rule in $agwRules) {
    az network application-gateway rule show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $rule
} 



$agwBackendsettings = az network application-gateway http-settings list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'setting')].name" | ConvertFrom-Json

foreach ($backendSetting in $agwBackendsettings) {
    az network application-gateway http-settings show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $backendSetting
}



$agwProbes = az network application-gateway probe list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'probe')].name" | ConvertFrom-Json

foreach ($probe in $agwProbes) {
    az network application-gateway probe show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $probe
}



$agwAddressPools = az network application-gateway address-pool list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'bepool')].name" | ConvertFrom-Json

foreach ($addressPool in $agwAddressPools) {
    az network application-gateway address-pool show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $addressPool
}




$agwHttpListeners = az network application-gateway http-listener list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'list')].name" | ConvertFrom-Json
    
foreach ($httpListener in $agwHttpListeners) {
    az network application-gateway http-listener show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $httpListener
}




$agwSslCerts = az network application-gateway ssl-cert list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'cert')].name" | ConvertFrom-Json

foreach ($sslCert in $agwSslCerts) {
    az network application-gateway ssl-cert show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $sslCert
}





$agwFrontendPorts = az network application-gateway frontend-port list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'Port')].name" | ConvertFrom-Json

foreach ($frontendPort in $agwFrontendPorts) {
    az network application-gateway frontend-port show `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $frontendPort
}










##
# Deleting in reverse order #
##

Write-Host "INFO deleting rule"
az network application-gateway rule delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name rule-$siteName

Write-Host "INFO deleting backend settings"
az network application-gateway http-settings delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "setting1-$siteName"

Write-Host "INFO deleting probe"
az network application-gateway probe delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "probe1-$siteName" 

Write-Host "INFO deleting address pool"
az network application-gateway address-pool delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "bepool1-$siteName"
        
Write-Host "INFO deleting http listener"
az network application-gateway http-listener delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name list-$siteName

Write-Host "INFO deleting ssl certificate"
az network application-gateway ssl-cert delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name cert-$siteName

Write-Host "INFO deleting frontend port"
az network application-gateway frontend-port delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name "Port_$($port)"



























# Deletion test
$agwRules = az network application-gateway rule list `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --query "[?starts_with(name, 'rule')].name" | ConvertFrom-Json

foreach ($rule in $agwRules) {
    az network application-gateway rule delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $rule
} 



$agwBackendsettings = az network application-gateway http-settings list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'setting')].name" | ConvertFrom-Json

foreach ($backendSetting in $agwBackendsettings) {
    az network application-gateway http-settings delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $backendSetting
}



$agwProbes = az network application-gateway probe list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'probe')].name" | ConvertFrom-Json

foreach ($probe in $agwProbes) {
    az network application-gateway probe delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $probe
}



$agwAddressPools = az network application-gateway address-pool list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'bepool')].name" | ConvertFrom-Json

foreach ($addressPool in $agwAddressPools) {
    az network application-gateway address-pool delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $addressPool
}




$agwHttpListeners = az network application-gateway http-listener list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'list')].name" | ConvertFrom-Json
    
foreach ($httpListener in $agwHttpListeners) {
    az network application-gateway http-listener delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $httpListener
}




$agwSslCerts = az network application-gateway ssl-cert list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'cert')].name" | ConvertFrom-Json

foreach ($sslCert in $agwSslCerts) {
    az network application-gateway ssl-cert delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $sslCert
}





$agwFrontendPorts = az network application-gateway frontend-port list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'Port')].name" | ConvertFrom-Json

foreach ($frontendPort in $agwFrontendPorts) {
    az network application-gateway frontend-port delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $frontendPort
}


# Frontend ports
Write-Host "INFO gathering frontend ports"
$agwFrontendPorts = az network application-gateway frontend-port list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?starts_with(name, 'Port')].name" | ConvertFrom-Json

Write-Host "INFO deleting frontend ports"
foreach ($frontendPort in $agwFrontendPorts) {
    az network application-gateway frontend-port delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $frontendPort

    Write-Host "Deleting frontend port $frontendPort"
}

























##
##### Gathering and deleting whole domain (site)
##
$siteName = "test-site-1"


$agwRules = az network application-gateway rule list `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwRules) {
    Write-Host "No rules found"
}    
else {
    foreach ($rule in $agwRules) {
        az network application-gateway rule delete `
        --resource-group $agwresourceGroup `
        --gateway-name $agwname `
        --name $rule
    } 
    Write-Host "deleting rule"
}



$agwBackendsettings = az network application-gateway http-settings list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwBackendsettings) {
    Write-Host "No Backend settings found"
}  

else {
    foreach ($backendSetting in $agwBackendsettings) {
        az network application-gateway http-settings delete `
        --resource-group $agwresourceGroup `
        --gateway-name $agwname `
        --name $backendSetting
    }
    Write-Host "deleting rule"
}



$agwProbes = az network application-gateway probe list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

foreach ($probe in $agwProbes) {
    az network application-gateway probe delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $probe
}



$agwAddressPools = az network application-gateway address-pool list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

foreach ($addressPool in $agwAddressPools) {
    az network application-gateway address-pool delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $addressPool
}




$agwHttpListeners = az network application-gateway http-listener list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json
    
foreach ($httpListener in $agwHttpListeners) {
    az network application-gateway http-listener delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $httpListener
}




$agwSslCerts = az network application-gateway ssl-cert list `
--resource-group $agwresourceGroup `
--gateway-name $agwname `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

foreach ($sslCert in $agwSslCerts) {
    az network application-gateway ssl-cert delete `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --name $sslCert
}















############
# delete multiple domains in one go
############


$siteName = "test-site-1"
$sites = "test-site-1","test-site-2","apple-site-2"
$domains = ($listenerAltNames -eq 'none') ? $domain : "$($domain),$($listenerAltNames)".Split(',')



$agwRules = az network application-gateway rule list `
    --resource-group $agwresourceGroup `
    --gateway-name $agwname `
    --query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwRules) {
    Write-Host "No rules found"
}    
else {
    foreach ($rule in $agwRules) {
        az network application-gateway rule delete `
        --resource-group $agwresourceGroup `
        --gateway-name $agwname `
        --name $rule
    } 
    Write-Host "deleting rule"
}