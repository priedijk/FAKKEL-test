# $storageAccount = Read-Host -Prompt 'Input the name of the Storage Account'
# $fileShare = Read-Host -Prompt 'Input the name of the File share'
# $SASToken = Read-Host -AsSecureString -Prompt 'Input the SAS token'

# $fileShareEndpoint="https://${storageAccount}.file.core.windows.net/"

# # nslookup "${storageAccount}.file.core.windows.net"

# [int]$choice = Read-Host "Enter number from 1-3"

# if (($choice -isnot [int])) { Throw 'You did not provide a number as input' }

# if (($choice -eq 1)) {
#     Write-Host "input is one"
# }
# if (($choice -eq 2)) {
#     Write-Host "input is two"
# }
# if (($choice -ne (1 -or 2))) {
#     Write-Host "invalid input"
# }


# PromptForChoice Args
$Title = "Do you want to proceed further?"
$Prompt = "Enter your choice"
$Choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No", "&Cancel")
$Default = 1

# Prompt for the choice
$Choice = $host.UI.PromptForChoice($Title, $Prompt, $Choices, $Default)

# Action based on the choice
switch($Choice)
{
    0 { 
        Write-Host "Yes - Write your code"
    }
    1 { 
        Write-Host "No - Write your code"
    }
    2 { 
        Write-Host "Cancel - Write your code"
    }
}
