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

elseif ( ${fileShareName} ) {

    Write-Output "Fileshare name has been given as input"
    $tokenType = "fileshare"
}

elseif ( ${containerName} ) {

    Write-Output "Blob container name has been given as input"
    $tokenType = "container"
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

$tokenAccess = "write"
$tokenValidity = 31

# validate SAS token validity
if (  ${tokenAccess} -eq "read" -and ${tokenValidity} -gt 365 ) {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Specified SAS token validity is longer then the allowed maximum duration of 1 year (365 days)"
    Write-Output "------------------------------------------------------------------------------------------------------"

    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### Specified SAS token validity is longer then the allowed maximum duration of 1 year (365 days)" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}

elseif (  ${tokenAccess} -eq "read" -and ${tokenValidity} -le 365 ) {

    Write-Output "Specified SAS token validity is within the maximum duration"
    $tokenPermission = "lr"
}

if ( ${tokenAccess} -eq "write" -and ${tokenValidity} -gt 31 ) {
    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Specified SAS token validity is longer then the allowed maximum duration of 1 Month (31 days)"
    Write-Output "------------------------------------------------------------------------------------------------------"

    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "#### Specified SAS token validity is longer then the allowed maximum duration of 1 Month year (31 days)" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    "------------------------------------------------------------------------------------------------------" | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append
    $validationFailed = $true
}

elseif ( ${tokenAccess} -eq "write" -and ${tokenValidity} -le 31 ) {
    
    Write-Output "Specified SAS token validity is within the maximum duration"
    $tokenPermission = "cdlrw"
}


# validate if storage account exists in subscription
$storageAccount = (az storage account list --query "[?starts_with(name, '${storageAccountName}')].name" -o tsv)
if (-not $storageAccount) {
    Write-Output "Could not find Storage Account."

    "Could not find Storage Account." | Out-File -FilePath $Env:GITHUB_STEP_SUMMARY -Encoding utf-8 -Append

    $validationFailed = $true
}
else {
    Write-Output "Storage Account ${storageAccountName} exists in the subscription"
}


# validate if fileshare or blob container exists




# Fail script if one more validation steps have failed
if ( ${validationFailed} -eq $true ) {
    Write-Output "At least one validation step has failed"
    exit 1
}    
elseif ( ${validationFailed} -eq $false ) {
    Write-Output "Validation has been passed successfully"
}


##########################################################################################################################################
###### Generate SAS token
##########################################################################################################################################

# Generate fileshare SAS token


$endDate = (Get-Date).AddDays(${tokenValidity})
$endDateFormatted = ${endDate}.ToString("yyyy-MM-ddTHH:mmZ")

if ( ${tokenType} -eq "fileshare" ) {

    $sasToken = (az storage share generate-sas `
            --name ${fileshareName} `
            --account-name ${storageAccountName} `
            --permissions ${tokenPermission} `
            --expiry ${endDateFormatted} `
            --https-only `
            -o tsv) 

    # masks output of sasToken
    Write-Output "::add-mask::${sasToken}"

    # Write-Output "STORAGE_SAS_TOKEN=${sasToken}" >> $GITHUB_ENV
    # Write-Output "SAS_END_DATE=${endDate}" >> $GITHUB_ENV

    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "fileshare SAS has been generated"
    Write-Output "------------------------------------------------------------------------------------------------------"
}


# Generate blob container SAS token
elseif ( ${tokenType} -eq "container" ) {

    $sasToken = (az storage container generate-sas `
            --name ${containerName} `
            --account-name ${storageAccountName} `
            --permissions ${tokenPermission} `
            --expiry ${endDateFormatted} `
            --https-only `
            -o tsv) 

    # masks output of sasToken
    Write-Output "::add-mask::${sasToken}"

    # Write-Output "STORAGE_SAS_TOKEN=${sasToken}" >> $GITHUB_ENV
    # Write-Output "SAS_END_DATE=${endDate}" >> $GITHUB_ENV

    Write-Output "------------------------------------------------------------------------------------------------------"
    Write-Output "Blob container SAS has been generated"
    Write-Output "------------------------------------------------------------------------------------------------------"
}

${sasToken}
${sasToken}
${sasToken}
