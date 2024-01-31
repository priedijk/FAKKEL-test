# Script to renew the eventhub authorization rule key in the shared_hub,
#    to rotate the eventhub authorization rule key and update the secret in the product teams keyvault
#

[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $hubSubscriptionId,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $eventhubKeyAction,
    [String] [Parameter (Mandatory = $true)]  $renewKey
)

# Define variables
if ($tenant.ToLower() -eq 'prd') {
    $eventhubNamespace = "evhns-${location}-001"
    
} else {
    $eventhubNamespace = "evhns-${location}-ae-001"
}

$resourceGroupName = "rg-evh-shared-${location}-001"
$eventhubName ="evh-monitoring-prod-${location}-001"
$authorizationRule ="sendonlyclaim"
# secret name for the eventhub authorization rule key
$eventhubSendKeyName = "eventhub-send-key"


# Get current activeSendKey tag value
$activeSendKey=(az eventhubs namespace show `
--resource-group $resourceGroupName `
--name $eventhubNamespace `
--query tags.active_send_key)

# Renew key when renew key is set to true
if ($eventhubKeyAction -eq "renew" -and $renewKey -eq $true ) {

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
if ($eventhubKeyAction -eq "rotate" -and $renewKey -eq $false ) {

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
    
# Put key in each product team keyvault.
    # loop over all files in config directory
    $files = Get-ChildItem ./foundation/landingzone/config/$tenant
    foreach ($file in $files) {
        Write-Output "-------"
        $teamName = $file.name.Split('.')[0].ToLower()
        Write-Output "INFO: teamName=$teamName"
        $team = (yq -o=json '.' $file | ConvertFrom-Json)
        foreach ($environment in $team.'landing-zones'.PSObject.Properties.Name) {
            # echo the environment
            Write-Output "INFO: environment=$environment"
            foreach ($landingZone in $team.'landing-zones'."$environment") {
                # echo the landingzone
                Write-Output "INFO: landingZone=$landingZone"
                $subscriptionName = "$($landingZone.'business-unit')-$($teamName)-$($environment)-$($landingZone.'instance-number')"
                # echo the subscription
                Write-Output "INFO: subscriptionName=$subscriptionName"
                $subscriptionId = ($subscriptionTags | Where-Object {$_.name -eq $subscriptionName}).subscriptionId
                if (!$subscriptionId ) { 
                    Write-Output "ERROR: subscriptionId '$subscriptionId' not found, skip this subscriptionId"
                } else { 
                    # echo the subscriptionId
                    Write-Output "INFO: subscriptionId=$subscriptionId"
                    $tags = ($subscriptionTags | Where-Object {$_.name -eq $subscriptionName}).tags
                    $keyvault = (az keyvault list --query "[?tags.owner=='$($teamName)']" | jq -r '.[] | .name')

                    # update the existing eventhub_send_key in the keyvaults
                    
                    # Set subscription
                    az account set -s $subscriptionId

                    # Update active send key secret in keyvaults
                    az keyvault secret set `
                    --vault-name $keyvault `
                    --name $eventhubSendKeyName `
                    --value $eventhubSendKeyValue

                } # end if-else subscriptionId
            } # end foreach landingZone
        } # end foreach environment
    } # end foreach file
}
