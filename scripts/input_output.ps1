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
$validationFailed = $false

# test vars
# $fileShareName = "jhj"
# $containerName = "jh"


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
if (( ${fileShareName} -eq $null -or ${fileShareName} -eq "" ) -and ( ${containerName} -eq $null -or ${containerName} -eq "" )) {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "A Fileshare or Blob container name must be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"

    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### A Fileshare or Blob container name must be given as an input" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}

# validate if fileshare name and container name are not defined
elseif (( ${fileShareName} -and ${containerName} )) {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Only one of Fileshare or Blob container name can be given as an input"
    Write-Output "------------------------------------------------------------------------------------------------------"

    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### Only one of Fileshare or Blob container name can be given as an input" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}

else {
    Write-Output "Fileshare or Blob container name has been provided"
}

# # validate password complexity
$regex = @” 
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\!@#$%^&*?])[A-Za-z\d\!@#$%^&*?]{12,}$
“@

if ( $zipPassword -cmatch $regex ) {
    Write-Output "Password matches the required complexity."
}
else {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Password does not meet the required complexity."
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Must be at least 12 characters"
    Write-Output "Must contain at least one lowercase letter"
    Write-Output "Must contain at least one uppercase letter"
    Write-Output "Must contain at least one special character - Special characters can only be one of !@#$%^&*?"
    Write-Output "Must contain at least one number"
    Write-Output "------------------------------------------------------------------------------------------------------"

    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "### Password does not meet the required complexity." | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### - Must be at least 12 characters" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### - Must contain at least one lowercase letter" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### - Must contain at least one uppercase letter" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### - Must contain at least one special character - Special characters can only be one of !@#$%^&*?" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### - Must contain at least one number" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}

# validate if storage account exists in subscription
$storageAccount = (az storage account list --query "[?starts_with(name, '${storageAccountName}')].name" -o tsv)
if (-not $storageAccount) {
    Write-Outpu "Could not find Storage Account."

    "Could not find Storage Account." | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}
else {
    Write-Output "Storage Account ${storageAccountName} exist in the subscription"
}

# validate if fileshare or blob container exists



if ( ${validationFailed} -eq $true ) {
    Write-Output "At least one validation step has failed"
    exit 1
}    
elseif ( ${validationFailed} -eq $false ) {
    Write-Output "Validation has been passed successfully"
}






# determine access and scope of SAS token
