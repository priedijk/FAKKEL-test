# Convert Input
storageAccountName=$1
fileShareName=$2
containerName=$3
zipPassword=$4
tokenAccess=$5
tokenValidity=$6

# Output input
echo "-----------------------------------------------------------------------------------"
echo "outputting variables"
echo "-----------------------------------------------------------------------------------"
echo "team = ${storageAccountName}"
echo "Fileshare Name = ${fileShareName}"
echo "Blob container name  = ${containerName}"
echo "Zip password  = ${zipPassword}"
echo "Token access = ${tokenAccess}"
echo "Token validity = ${tokenValidity}"
echo "-----------------------------------------------------------------------------------"

# validation
if [[ -z ${fileShareName}  && -z ${containerName} ]]; then
    echo "------------------------------------------------------------------------------------------------------"
    echo "A Fileshare or Blob container name must be given as an input"
    echo "------------------------------------------------------------------------------------------------------"

    {
    echo "------------------------------------------------------------------------------------------------------"
    echo "#### A Fileshare or Blob container name must be given as an input"
    echo "------------------------------------------------------------------------------------------------------"
    } >> $GITHUB_STEP_SUMMARY 
fi

if [[ "${fileShareName}" != ""  &&  "${containerName}" != "" ]]; then
    echo "------------------------------------------------------------------------------------------------------"
    echo "Only one of Fileshare or Blob container name can be given as an input"
    echo "------------------------------------------------------------------------------------------------------"

    {
    echo "------------------------------------------------------------------------------------------------------"
    echo "#### Only one of Fileshare or Blob container name can be given as an input"
    echo "------------------------------------------------------------------------------------------------------"
    } >> $GITHUB_STEP_SUMMARY
fi


# $tfStateStorage = az storage account list --query "[?starts_with(name,'sttfstate') && location=='westeurope'].name" --subscription ${{ env.ARM_SUBSCRIPTION_ID }} -o tsv
# if (-not $tfStateStorage) {
#     Write-Error "ERROR Could not determine storage account for Terraform state."
#     Exit 1
# }