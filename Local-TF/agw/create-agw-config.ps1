$agw = az network application-gateway list | ConvertFrom-Json
if (-not $agw) {
    Write-Error "ERROR Failed to discover application gateway to use."
}

# number 1
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
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "Port_$($port)" `
    --port $port

Write-Host "INFO create ssl certificate"
az network application-gateway ssl-cert create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --cert-file "certs/mycert.pfx" `
    --cert-password "defh123" `
    --name cert-$siteName

Write-Host "INFO create http listener"
az network application-gateway http-listener create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --frontend-port "Port_$($port)" `
    --name list-$siteName `
    --frontend-ip $frontendIpName `
    --host-names $listenerHostNames `
    --ssl-cert cert-$siteName

Write-Host "INFO create address pool"
az network application-gateway address-pool create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "bepool1-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "probe1-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "setting1-$siteName" `
    --host-name $backendHostName `
    --probe "probe1-$siteName" `
    --protocol Https `
    --port 8443

Write-Host "INFO create rule"
az network application-gateway rule create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
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
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "bepool2-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "probe2-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "setting2-$siteName" `
    --host-name $backendHostName `
    --probe "probe2-$siteName" `
    --protocol Https `
    --port 8443



# Create number 2
# number 2
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
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --cert-file "certs/mycert.pfx" `
    --cert-password "defh123" `
    --name cert-$siteName

Write-Host "INFO create http listener"
az network application-gateway http-listener create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --frontend-port "Port_$($port)" `
    --name list-$siteName `
    --frontend-ip $frontendIpName `
    --host-names $listenerHostNames `
    --ssl-cert cert-$siteName

Write-Host "INFO create address pool"
az network application-gateway address-pool create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "bepool1-$siteName" `
    --servers $serverIp

Write-Host "INFO create probe"
az network application-gateway probe create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "probe1-$siteName" `
    --protocol Https `
    --host-name-from-http-settings true `
    --path $healthProbe

Write-Host "INFO create backend settings"
az network application-gateway http-settings create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name "setting1-$siteName" `
    --host-name $backendHostName `
    --probe "probe1-$siteName" `
    --protocol Https `
    --port 8443

Write-Host "INFO create rule"
az network application-gateway rule create `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --name rule-$siteName `
    --priority $priority `
    --address-pool bepool1-$siteName `
    --http-listener list-$siteName `
    --rule-type Basic `
    --http-settings setting1-$siteName