# Scans all app keyvaults and renews ITOPCI managed certificates that expire within CERT_RENEW_WINDOW_DAYS
Function RenewCertificate {
    param($certificateName, $certificateId, $keyvault, $tags)

    $password = ConvertTo-SecureString $Env:TPP_PASSWORD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($Env:TPP_USER, $password)
    New-VenafiSession -Server $Env:TPP_SERVER -Credential $credential

    Invoke-VenafiCertificateAction -CertificateID $certificateId -Renew

    $retries = 0
    $retryCount = 10
    while ($retries -lt $retryCount) {
        try {
            $certificateInfo = Get-VenafiCertificate -CertificateId $certificateId
            if (-not $certificateInfo.Disabled -and -not $certificateInfo.CertificateDetails.RevocationStatus) {
                $timeDiff = New-TimeSpan -Start (Get-Date) -End $certificateInfo.CertificateDetails.ValidTo
                if ($timeDiff.Days -ge $Env:CERT_RENEW_WINDOW_DAYS) {
                    # we have a valid certificate
                    break
                }
            }
        }
        catch {
            Write-Warning $Error[0]
        }
        Write-Host "INFO Waiting for certificate creation/renewal. Sleeping 30 seconds"
        Start-Sleep -Seconds 30
        $retries++
    }

    if ($retries -ge $retryCount) {
        Write-Error "Error Failed to obtain valid certificate from Venafi."
        Exit 1
    }

    # export certificate
    $keyPassword = [guid]::NewGuid()
    Export-VenafiCertificate -CertificateID $certificateId  -Format 'PKCS #12' -PrivateKeyPassword (ConvertTo-SecureString $keyPassword -AsPlainText -Force) -IncludeChain -OutPath (Get-Location).Path
    if (!(Test-Path -Path "$($tags.domain).pfx")) {
        Write-Error "ERROR Certificate enrolment failed. No pks12 file with name $($tags.domain).pfx found."
    }
    Write-Host "INFO Importing certifcate $($tags.domain) in keyvault $($keyvault)."
    az keyvault certificate import --name $certificateName --vault-name "$($keyvault)" --file "$($tags.domain).pfx" --password $keyPassword --tags managed-by=itopci policy=$($tags.policy) domain=$($tags.domain) auto-renew=true --output none
    # cleanup
    Remove-Item -Force *.pfx
}

# main
az config set extension.use_dynamic_install=yes_without_prompt
$keyvaults = (az graph query -q "where type =~ 'microsoft.keyvault/vaults' | where tags.logicalname =~ 'keyvault-app'" --first 1000 | ConvertFrom-Json).data
foreach ($keyvault in $keyvaults) {
    Write-Host "INFO processing keyvault $($keyvault.name)"
    $certificates = az keyvault certificate list --vault-name $($keyvault.name) | ConvertFrom-Json
    foreach ($certificate in $certificates) {
        if (($certificate.tags.'managed-by' -eq 'itopci') -and ($certificate.tags.'auto-renew' -eq 'true')) {
            if ($certificate.attributes.enabled) {
                $timeDiff = New-TimeSpan -Start (Get-Date) -End $certificate.attributes.expires
                if ($timeDiff.Days -lt $Env:CERT_RENEW_WINDOW_DAYS) {
                    Write-Host "INFO certificate $($certificate.name) in keyvault $($keyvault.name) expires in $($timeDiff.Days) days wich is is less then configured renew widow of $($Env:CERT_RENEW_WINDOW_DAYS). Renewing certificate."
                    $subscriptionName = az account show -s $keyvault.subscriptionId --query name -o tsv
                    RenewCertificate -certificateName $certificate.name -certificateId "$($certificate.tags.policy)\$($subscriptionName)\$($certificate.tags.domain)" -keyvault $keyvault.name -tags $certificate.tags
                }
                else {
                    Write-Host "INFO certificate $($certificate.name) in keyvault $($keyvault.name) expires in $($timeDiff.Days) days wich is is more then configured renew widow of $($Env:CERT_RENEW_WINDOW_DAYS). Ignoring."
                }
            }
            else {
                Write-Host "INFO certificate $($certificate.name) in keyvault $($keyvault.name) is managed by ITOPCI but is disabled. Ignoring."
            }
        }
        else {
            Write-Host "INFO certificate $($certificate.name) in keyvault $($keyvault.name) is not managed by ITOPCI. Ignoring."
        }
    }
}