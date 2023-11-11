[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $storageAccountName,
    [String] [Parameter (Mandatory = $true)]  $zipPassword,
    [String] [Parameter (Mandatory = $true)]  $tokenAccess,
    [String] [Parameter (Mandatory = $true)]  $tokenValidity,
    [String] $fileShareName,
    [String] $containerName
)

# set vars
$validationFailed=$false

# Output input
Write-Output "-----------------------------------------------------------------------------------"
Write-Output "outputting variables"
Write-Output "-----------------------------------------------------------------------------------"
Write-Output "storageAccountName = ${storageAccountName}"
Write-Output "Fileshare Name = ${fileShareName}"
Write-Output "Blob container name = ${containerName}"
Write-Output "Zip password = ${zipPassword}"
Write-Output "Token access = ${tokenAccess}"
Write-Output "Token validity = ${tokenValidity}"
Write-Output "-----------------------------------------------------------------------------------"


##########################################################################################################################################
###### validation steps
##########################################################################################################################################

# validate if fileshare name and container name are not both empty
if (( ${fileShareName} -eq $null -or ${fileShareName} -eq "" ) -and ( ${containerName} -eq $null -or ${containerName} -eq "" )) 
{
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "A Fileshare or Blob container name must be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"

    {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "#### A Fileshare or Blob container name must be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"
    } >> $GITHUB_STEP_SUMMARY 

    $validationFailed=$true
}

# validate if fileshare name and container name are not defined
elseif (( ${fileShareName} -ne $null -or ${fileShareName} -ne "" ) -and ( ${containerName} -ne $null -or ${containerName} -ne "" )) 
{
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Only one of Fileshare or Blob container name can be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"

    {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "#### Only one of Fileshare or Blob container name can be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"
    } >> $GITHUB_STEP_SUMMARY

    $validationFailed=$true
}

else
{
    Write-Output "Fileshare or Blob container name has been provided"
}


# # validate password complexity
$regex = @” 
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\!@#$%^&*?])[A-Za-z\d\!@#$%^&*?]{12,}$
“@

if ( $zipPassword -cmatch $regex )
{
    Write-Output "Password matches the required complexity."
}
else
{
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Password does not meet the required complexity."
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Must be at least 12 characters"
    Write-Output "Must contain at least one lowercase letter"
    Write-Output "Must contain at least one uppercase letter"
    Write-Output "Must contain at least one special character - Special characters can only be one of !@#$%^&*?"
    Write-Output "Must contain at least one number"
    Write-Output "------------------------------------------------------------------------------------------------------"

    {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "### Password does not meet the required complexity."
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "#### - Must be at least 12 characters"
    Write-Output "#### - Must contain at least one lowercase letter"
    Write-Output "#### - Must contain at least one uppercase letter"
    Write-Output "#### - Must contain at least one special character - Special characters can only be one of !@#$%^&*?"
    Write-Output "#### - Must contain at least one number"
    Write-Output "------------------------------------------------------------------------------------------------------"
    } >> $GITHUB_STEP_SUMMARY

    $validationFailed=$true
}


az storage account list




if ( ${validationFailed} -eq $true )
{
    Write-Output "At least one validation step has failed"
    exit 1
}    
elseif ( ${validationFailed} -eq $false )
{
    Write-Output "Validation has been passed successfully"
}




# $tfStateStorage = az storage account list --query "[?starts_with(name,'sttfstate') && location=='westeurope'].name" --subscription ${{ env.ARM_SUBSCRIPTION_ID }} -o tsv
# if (-not $tfStateStorage) {
#     Write-Error "ERROR Could not determine storage account for Terraform state."
#     Exit 1
# }