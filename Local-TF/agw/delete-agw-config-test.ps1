
$siteName = "test-site-1"

$agw = az network application-gateway list | ConvertFrom-Json
if (-not $agw) {
    Write-Error "ERROR Failed to discover application gateway to use."
}
##
# Gathering information and deleting the resources #
##

# Rules
Write-Host "INFO gathering rule"
$agwRule = az network application-gateway rule list `
    --resource-group $($agw.resourceGroup) `
    --gateway-name $($agw.name) `
    --query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json


if (!$agwRule) {
    Write-Host "No rule found for this domain"
} 

else {
    Write-Host "INFO deleting rule $agwRule"

        az network application-gateway rule delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $agwRule 
}


# Backend settings
Write-Host "INFO gathering backend settings"

$agwBackendsettings = az network application-gateway http-settings list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwBackendsettings) {
    Write-Host "No backend settings found for this domain"
} 

else {
    Write-Host "INFO deleting backend settings"

    foreach ($backendSetting in $agwBackendsettings) {

        Write-Host "Deleting backend setting $backendSetting"

        az network application-gateway http-settings delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $backendSetting
    }
}


# Health probes
Write-Host "INFO gathering health probes"
$agwProbes = az network application-gateway probe list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwProbes) {
    Write-Host "No health probes found for this domain"
} 

else {
    Write-Host "INFO deleting health probes"

    foreach ($probe in $agwProbes) {

        Write-Host "Deleting health probe $probe"

        az network application-gateway probe delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $probe
    }
}

# Backend pools
Write-Host "INFO gathering backend pools"
$agwAddressPools = az network application-gateway address-pool list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwAddressPools) {
    Write-Host "No backend pools found for this domain"
} 

else {
    Write-Host "INFO deleting backend pools"

    foreach ($addressPool in $agwAddressPools) {

        Write-Host "Deleting backend pool $addressPool"

        az network application-gateway address-pool delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $addressPool
    }
}


# HTTP listeners
Write-Host "INFO gathering HTTP listener"
$agwHttpListener = az network application-gateway http-listener list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json
 
if (!$agwHttpListener) {
    Write-Host "No HTTP listener found for this domain"
} 

else {
    Write-Host "INFO deleting HTTP listener $agwHttpListener"

        az network application-gateway http-listener delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $agwHttpListener
}


# SSL certificates
Write-Host "INFO gathering SSL certificate"
$agwSslCert = az network application-gateway ssl-cert list `
--resource-group $($agw.resourceGroup) `
--gateway-name $($agw.name) `
--query "[?ends_with(name, '$($sitename)')].name" | ConvertFrom-Json

if (!$agwSslCert) {
    Write-Host "No SSL certificate found for this domain"
} 

else {
    Write-Host "INFO deleting SSL certificate $agwSslCert"

        az network application-gateway ssl-cert delete `
        --resource-group $($agw.resourceGroup) `
        --gateway-name $($agw.name) `
        --name $agwSslCert
}
