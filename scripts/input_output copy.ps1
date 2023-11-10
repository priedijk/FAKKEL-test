[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $storageAccountName,
    [String] [Parameter (Mandatory = $true)]  $zipPassword,
    [String] [Parameter (Mandatory = $true)]  $tokenAccess,
    [String] [Parameter (Mandatory = $true)]  $tokenValidity,
    [String] $fileShareName
    [String] $containerName
)

# set vars
$validationFailed=$false

# Output input
echo "-----------------------------------------------------------------------------------"
echo "outputting variables"
echo "-----------------------------------------------------------------------------------"
echo "storageAccountName = ${storageAccountName}"
echo "Fileshare Name = ${fileShareName}"
echo "Blob container name = ${containerName}"
echo "Zip password = ${zipPassword}"
echo "Token access = ${tokenAccess}"
echo "Token validity = ${tokenValidity}"
echo "-----------------------------------------------------------------------------------"

if ($fileShareName)
{
   echo "fileshare has an input"
}
else
{
    echo "fileshare has no input"
}

if ($containerName)
{
   echo "fileshare has an input"
}
else
{
    echo "fileshare has no input"
}

echo $validationFailed


# # validation
# if [[ -z ${2}  ||  "${2}" == "" ]] && [[ -z ${3}  ||  "${3}" == "" ]]; then
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "A Fileshare or Blob container name must be given as an input"
#     echo "------------------------------------------------------------------------------------------------------"

#     {
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "#### A Fileshare or Blob container name must be given as an input"
#     echo "------------------------------------------------------------------------------------------------------"
#     } >> $GITHUB_STEP_SUMMARY 

#     validationFailed=true
# else 
#     echo "a name has been given"
# fi

# elif [[ "${fileShareName}" != ""  &&  "${containerName}" != "" ]]; then
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "Only one of Fileshare or Blob container name can be given as an input"
#     echo "------------------------------------------------------------------------------------------------------"

#     {
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "#### Only one of Fileshare or Blob container name can be given as an input"
#     echo "------------------------------------------------------------------------------------------------------"
#     } >> $GITHUB_STEP_SUMMARY

#     validationFailed=true
# fi

# # validate password complexity
# regex="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\!@#$%^&*?])[A-Za-z\d\!@#$%^&*?]{12,}$"

# if [[ $(echo ${zipPassword} | grep -P "$regex") ]]; then

#     echo "Password matches the required complexity."

# else

#     echo "------------------------------------------------------------------------------------------------------"
#     echo "Password does not meet the required complexity."
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "Must be at least 12 characters"
#     echo "Must contain at least one lowercase letter"
#     echo "Must contain at least one uppercase letter"
#     echo "Must contain at least one special character - Special characters can only be one of !@#$%^&*?"
#     echo "Must contain at least one number"
#     echo "------------------------------------------------------------------------------------------------------"

#     {
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "### Password does not meet the required complexity."
#     echo "------------------------------------------------------------------------------------------------------"
#     echo "#### - Must be at least 12 characters"
#     echo "#### - Must contain at least one lowercase letter"
#     echo "#### - Must contain at least one uppercase letter"
#     echo "#### - Must contain at least one special character - Special characters can only be one of !@#$%^&*?"
#     echo "#### - Must contain at least one number"
#     echo "------------------------------------------------------------------------------------------------------"
#     } >> $GITHUB_STEP_SUMMARY

#     validationFailed=true
# fi



# $tfStateStorage = az storage account list --query "[?starts_with(name,'sttfstate') && location=='westeurope'].name" --subscription ${{ env.ARM_SUBSCRIPTION_ID }} -o tsv
# if (-not $tfStateStorage) {
#     Write-Error "ERROR Could not determine storage account for Terraform state."
#     Exit 1
# }

# if [[ "${validationFailed}" == true ]]; then
#     exit 1

# elif [[ "${validationFailed}" == false ]]; then
#     echo "Validation has been passed successfully"

# fi
