az login 
az config set extension.use_dynamic_install=yes_without_prompt

$keyvaults = (az graph query -q "where type =~ 'microsoft.keyvault/vaults' | where tags.logicalname =~ 'keyvault-app'" --first 1000 | ConvertFrom-Json).data
foreach ($keyvault in $keyvaults) {
    Write-Host "INFO processing keyvault $($keyvault.name)"
}


$environment = "nonprod"
$environment = "prod"

az keyvault secret show --name "y" --vault-name ""

$eventhubNamespace = ""
$resourceGroupName = ""
$eventhubName =""
$authorizationRule =""
$eventhubSendKeyName = ""
$eventhubSendKey1Value = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhubName --name $authorizationRule --query "primaryConnectionString")
$eventhubSendKey2Value = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhubName --name $authorizationRule --query "secondaryConnectionString")
Write-Output $eventhubSendKey1Value
Write-Output $eventhubSendKey2Value

if($?) {
    Write-Output "Key successfully rotated"
}
else {
    Write-Output "Key rotation was not successfull"
}
# Script to renew the eventhub authorization rule key in the shared_hub,
#    to rotate the eventhub authorization rule key and update the secret in the product teams keyvault
#

[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $hubSubscriptionId,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $environment,
    [String] [Parameter (Mandatory = $true)]  $eventhubKeyAction
)

# Define variables
if ($tenant.ToLower() -eq 'prd') {
    $eventhubNamespace = "evhns-${location}-001"
    
} else {
    $eventhubNamespace = "evhns-${location}-ae-001"
}

$resourceGroupName = ""
$eventhubName =""
$authorizationRule =""
# secret name for the eventhub authorization rule key
$eventhubSendKeyName = ""


# Get current activeSendKey tag value
$activeSendKey=(az eventhubs namespace show `
--resource-group $resourceGroupName `
--name $eventhubNamespace `
--query tags.active_send_key)

# Renew key when renew key is set to true
if ($eventhubKeyAction -eq "renew") {

    if (${activeSendKey} -match "key1") {
        Write-Output "active_send_Key is ${activeSendKey}"
        $keyToRenew = "SecondaryKey"
        Write-Output "Rotating `"key2`""
    }
    elseif (${activeSendKey} -match "key2") {
        Write-Output "active_send_Key is ${activeSendKey}"
        $keyToRenew = "PrimaryKey"
        Write-Output "Rotating `"key1`""
    }

    az eventhubs eventhub authorization-rule keys renew `
        --resource-group $resourceGroupName `
        --namespace-name $eventhubNamespace `
        --eventhub-name $eventhubName `
        --name $authorizationRule `
        --key $keyToRenew
}

# Define new active_key to set if only rotating the key
if ($eventhubKeyAction -eq "rotate" ) {

    if (${activeSendKey} -match "key1") {
        Write-Output "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key2"
        $keyToRotate = "secondaryKey"
        $connectionStringToRotate = "secondaryConnectionString"
        Write-Output "active_send_Key set to `"key2`""
    }
    elseif (${activeSendKey} -match "key2") {
        Write-Output "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key1"
        $keyToRotate = "primaryKey"
        $connectionStringToRotate = "primaryConnectionString"
        Write-Output "active_send_Key set to `"key1`""
    }

    # Get eventhub authorization rule key
    $eventhubSendKeyValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhubName --name $authorizationRule --query $connectionStringToRotate)
        
    # Set new active_send_key tag value
    az eventhubs namespace update `
    --resource-group $resourceGroupName `
    --name $eventhubNamespace `
    --tags active_send_key=$newActiveSendKey

    # Query all product team keyvaults based on input of environment and update the Eventhub authorization rule connection string secret.
    az config set extension.use_dynamic_install=yes_without_prompt
    $keyvaults = (az graph query -q "where type =~ 'microsoft.keyvault/vaults' | where tags.logicalname =~ 'keyvault-app' and tags.environment == '$($environment)'" --first 1000 | ConvertFrom-Json).data
    foreach ($keyvault in $keyvaults) {
        Write-Host "INFO processing keyvault $($keyvault.name)"

        az keyvault secret set `
        --vault-name $keyvault `
        --name $eventhubSendKeyName `
        --value $eventhubSendKeyValue
        
    }
}

