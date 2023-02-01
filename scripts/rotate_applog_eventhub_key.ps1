# Script to 
#    - renew the eventhub authorization rule key in the shared_hub,
#    - rotate the eventhub authorization rule key and update the secret in the product teams keyvault
#

[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $hubSubscriptionId,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $environment,
    [String] [Parameter (Mandatory = $true)]  $eventhubKeyAction
)

az account set --subscription ${hubSubscriptionId}
write-host "INFO Hubscription set to ${hubSubscriptionId}"

# Define variables

$resourceGroupName = "rg-evhns-rotation-001"
$eventhubNamespace = "evhns-rotation-001"
$eventhubName ="evh-rotation-001"
$authorizationRule ="sendonly"
# secret name for the eventhub authorization rule key
$eventhubSendKeyName = "send-key"


# Get current activeSendKey tag value
$activeSendKey=(az eventhubs namespace show `
--resource-group $resourceGroupName `
--name $eventhubNamespace `
--query tags.active_send_key)

# Renew key when renew key is set to true
if ($eventhubKeyAction -eq "renew") {

    if (${activeSendKey} -match "key1") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key is ${activeSendKey} (PrimaryKey)"
        $keyToRenew = "SecondaryKey"
        Write-Output "Rotating `"SecondaryKey`""
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }
    elseif (${activeSendKey} -match "key2") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key is ${activeSendKey} (SecondaryKey)"
        $keyToRenew = "PrimaryKey"
        Write-Output "Rotating `"PrimaryKey`""
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }
    az eventhubs eventhub authorization-rule keys renew `
        --resource-group $resourceGroupName `
        --namespace-name $eventhubNamespace `
        --eventhub-name $eventhubName `
        --name $authorizationRule `
        --key $keyToRenew `
        # --output none

    if($?) {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "Key successfuly rotated"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "Key rotation was not successful"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
        $successful = $false
    }
}

# Define new active_key to set if only rotating the key
if ($eventhubKeyAction -eq "rotate" ) {

    if (${activeSendKey} -match "key1") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key2"
        $connectionStringToRotate = "secondaryConnectionString"
        Write-Output "active_send_Key set to `"key2`" (SecondaryKey)"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }
    elseif (${activeSendKey} -match "key2") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key1"
        $connectionStringToRotate = "primaryConnectionString"
        Write-Output "active_send_Key set to `"key1`" (PrimaryKey)"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }

    # Get eventhub authorization rule key
    $eventhubSendKeyValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhubName --name $authorizationRule --query $connectionStringToRotate)
        
    # Set new active_send_key tag value
    Write-Host ""
    Write-Host "--------------------------------------------------------------"
    Write-Output "Updating active_send_key tag"
    Write-Host "--------------------------------------------------------------"
    Write-Host ""
    
    $eventhubNamespaceId = (az eventhubs namespace show --resource-group $resourceGroupName --name $eventhubNamespace --query "id")
    
    az tag update `
    --resource-id $eventhubNamespaceId `
    --operation merge `
    --tags active_send_key=$newActiveSendKey


    if($?) {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_key tag successfully updated"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
        
    }
    else {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "Updating the active_send_key tag was not successful"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
        $successful = $false
    }
    
    # Query all product team keyvaults based on input of environment and update the Eventhub authorization rule connection string secret.
    az config set extension.use_dynamic_install=yes_without_prompt
    $keyvaults = (az graph query -q "where type =~ 'microsoft.keyvault/vaults' | where tags.logicalname =~ 'keyvault-app' and tags.environment == '$($environment)'" --first 1000 | ConvertFrom-Json).data
    Write-Host ""
    Write-Host "------------------------------------------------------------------"
    Write-Host "updating eventhub_key secret with value of ${activeSendKey} for:"
    Write-Host "------------------------------------------------------------------"
    ${keyvaults}.name
    Write-Host "------------------------------------------------------------------"
    Write-Host ""
    
    foreach ($keyvault in $keyvaults) {
        Write-Host "INFO processing keyvault $($keyvault.name)"

        az keyvault secret set `
        --vault-name $($keyvault.name) `
        --name $eventhubSendKeyName `
        --value $eventhubSendKeyValue `
        --tags "eventhub=$($eventhubName)" "namespace=$($eventhubNamespace)" "key=$($newActiveSendKey)" `
        # --output none

        if($?) {
            Write-Host ""
            Write-Host "--------------------------------------------------------------"
            Write-Output "Secret successfully updated"
            Write-Host "--------------------------------------------------------------"
            Write-Host ""
            }
        else {
            Write-Host ""
            Write-Host "--------------------------------------------------------------"
            Write-Output "Updating the secret was not successful"
            Write-Host "--------------------------------------------------------------"
            Write-Host ""
            $successful = $false
        }
    }
}


# Distribute current active key to product teams
if ($eventhubKeyAction -eq "distribute" ) {

    if (${activeSendKey} -match "key1") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key is ${activeSendKey}"
        $connectionString = "primaryConnectionString"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }
    elseif (${activeSendKey} -match "key2") {
        Write-Host ""
        Write-Host "--------------------------------------------------------------"
        Write-Output "active_send_Key is ${activeSendKey}"
        $connectionString = "secondaryConnectionString"
        Write-Host "--------------------------------------------------------------"
        Write-Host ""
    }

    # Get eventhub authorization rule key
    $eventhubSendKeyValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhubName --name $authorizationRule --query $connectionString)
    # Query all product team keyvaults based on input of environment and update the Eventhub authorization rule connection string secret.
    az config set extension.use_dynamic_install=yes_without_prompt
    $keyvaults = (az graph query -q "where type =~ 'microsoft.keyvault/vaults' | where tags.logicalname =~ 'keyvault-app' and tags.environment == '$($environment)'" --first 1000 | ConvertFrom-Json).data
    Write-Host ""
    Write-Host "--------------------------------------------------------------"
    Write-Host "Distributing ${activeSendKey} to:"
    Write-Host "--------------------------------------------------------------"
    ${keyvaults}.name
    Write-Host "--------------------------------------------------------------"
    Write-Host ""

    foreach ($keyvault in $keyvaults) {
        Write-Host "INFO processing keyvault $($keyvault.name)"

        az keyvault secret set `
        --vault-name $($keyvault.name) `
        --name $eventhubSendKeyName `
        --value $eventhubSendKeyValue `
        --tags "eventhub=$($eventhubName)" "namespace=$($eventhubNamespace)" "key=$($newActiveSendKey)" `
        # --output none
        
        if($?) {
            Write-Host ""
            Write-Host "--------------------------------------------------------------"
            Write-Output "Secret successfully updated"
            Write-Host "--------------------------------------------------------------"
            Write-Host ""
            }
        else {
            Write-Host ""
            Write-Host "--------------------------------------------------------------"
            Write-Output "Updating the secret was not successful"
            Write-Host "--------------------------------------------------------------"
            Write-Host ""
            $successful = $false
        }
    }
}

if ($successful -eq $false) {
    Write-Host "The script has not completed succesfully, exiting"
    exit 1
}
