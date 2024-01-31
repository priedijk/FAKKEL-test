[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $renewKey
)
az login 
az account set -s "SUBSCRIPTION"


# Get current activeSendKey tag value
$renewKey = $true
$renewKey = $false
$resourceGroupName="eventhub"
$eventhubNamespace="taggingeventhubtest"
$eventhub="no-tags"
$authorizationRule="sendonly"
$keyvault = "eventhub"
$eventhubSendKeyName = "eventhub-send-key"


$keyvault = (az keyvault list --query "[?tags.environment=='production']" | jq -r '.[] | .name')

# Get current activeSendKey tag value
$activeSendKey=(az eventhubs namespace show `
--resource-group $resourceGroupName `
--name $eventhubNamespace `
--query tags.active_send_key)

# Renew key when renew key is set to true
if ($renewKey -eq $true ) {
echo "renew key is true, will renew the eventhub authorization rule key"

    if (${activeSendKey} -match "key1") {
        echo "active_send_Key is ${activeSendKey}"
        $keyToRotate = "SecondaryKey"
        echo "Rotating `"key2`""
    }
    elseif ($activeSendKey -match "key2") {
        echo "active_send_Key is ${activeSendKey}"
        $keyToRotate = "PrimaryKey"
        echo "Rotating `"key1`""
    }
    az eventhubs eventhub authorization-rule keys renew `
        --resource-group $resourceGroupName `
        --namespace-name $eventhubNamespace `
        --eventhub-name $eventhub `
        --name $authorizationRule `
        --key $keyToRotate
        # PrimaryKey, SecondaryKey.
}

# Define new active_key to set if only rotating the key
if ($renewKey -eq $false ) {
    echo "renew key is false, will rotate the eventhub authorization rule key in the keyvault"

    if (${activeSendKey} -match "key1") {
        echo "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key2"
        $keyToRotate = "secondaryKey"
        $connectionStringToRotate = "secondaryConnectionString"
        echo "active_send_Key set to `"key2`""
    }
    elseif ($activeSendKey -match "key2") {
        echo "active_send_Key was ${activeSendKey}"
        $newActiveSendKey = "key1"
        $keyToRotate = "primaryKey"
        $connectionStringToRotate = "primaryConnectionString"
        echo "active_send_Key set to `"key1`""
    }

    # Get eventhub authorization rule key
    $eventhubSendKeyValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhub --name $authorizationRule --query $keyToRotate)
    # Update secret in keyvault with new key value
    echo "Updating key in keyvault"
    az keyvault secret set `
        --vault-name $keyvault `
        --name $eventhubSendKeyName `
        --value $eventhubSendKeyValue `
        --tags "eventhub=$($eventhub)" "namespace=$($eventhubNamespace)" "key=$($newActiveSendKey)"


    # Set new activeSendKey value
    echo "Setting new active_send_key tag value"
    az eventhubs namespace update `
    --resource-group $resourceGroupName `
    --name $eventhubNamespace `
    --tags active_send_key=$newActiveSendKey
}

$keyvault = "eventhub"
$eventhubSendKeyName = "eventhubsendkey"
$eventhubSendKeyValue = "testvalue"

az keyvault secret set `
 --vault-name $keyvault `
 --name $eventhubSendKey `
 --value $eventhubSendKeyValue

 az keyvault secret list --vault-name mykeyvault --tag environment=production
 az keyvault secret show --vault-name mykeyvault --name mysecret

# key1
$eventhubSendKeyValue =(az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhub --name $authorizationRule --query primaryKey)
# connection string 1
$eventhubSendConnectionStringValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhub --name $authorizationRule --query primaryConnectionString)
# key2
$eventhubSendKeyValue =(az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhub --name $authorizationRule --query secondaryKey)
# connection string 2
$eventhubSendConnectionStringValue = (az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroupName --namespace-name $eventhubNamespace --eventhub-name $eventhub --name $authorizationRule --query secondaryConnectionString)

echo $eventhubSendKeyValue
echo $eventhubSendConnectionStringValue
echo 
echo 

# Put key in each product team keyvault.

$renewKey="true"
$action="renew"


if ($renewKey -eq $true -and $action -eq "renew" ) {
        echo "and condition working"
}
