# Script to create an overview of all landingzones 
#    and report foundation and config versions
#

# Get input
[CmdletBinding()]
param(
    # name for the config directory that is going to be processed
    # for example 'AE' or 'PRD'
    [String] [Parameter (Mandatory = $true)]  $tenant,
    [String] [Parameter (Mandatory = $true)]  $hubSubscriptionId,
    [String] $ghWorkflow, # github.workflow
    [String] $ghEvent, # github.event
    [String] $ghRepository, # github.repository
    [String] $fileName      # base name of the output files
)

# fill fields if not filled by Github Action
if (!$ghWorkflow) { $ghWorkflow = "manual" }
if (!$ghEvent) { $ghEvent = "manual start - not scheduled" }
if (!$ghRepository) { $ghRepository = "FAKKEL-test" }
if (!$fileName) { $fileName = "lz-tf-diff" }

## OUTPUTFILES
$datafile = "report/${fileName}.json"
$metafile = "report/${fileName}.txt"

az config set extension.use_dynamic_install=yes_without_prompt
# $subscriptionTags = (az graph query -q "ResourceContainers | where isempty(resourceGroup) | project subscriptionId,name,tags" --first 1000 | ConvertFrom-Json).data

[System.Collections.ArrayList]$landingZones = @()
# loop over all files in config directory
mkdir -p report/plan-output
$files = "action-group-test"
$subscriptionName=$hubSubscriptionId
Write-Output "echo vars"
$hubSubscriptionId
$subscriptionName
Write-Output "-------"
Write-Output "directory = ${pwd}"
Write-Output "-------"
Get-ChildItem report
Get-ChildItem report/plan-output
exit 1

terraform -chdir=action-group-test init -lock=false `
    -backend-config="key=action-group.tfstate" `
    -backend-config="resource_group_name=$($Env:TF_STATE_RESOURCE_GROUP)" `
    -backend-config="storage_account_name=$($Env:TF_STATE_STORAGE)"

terraform -chdir=action-group-test plan -no-color -input=false -lock=false -detailed-exitcode -out="report/plan-output/test.tfplan" `
    # --var-file=environment-$($environment).tfvars `
    # --var-file=tenant-$($tenant.ToLower()).tfvars `
    # --var-file=../config/all/ip-lists/afkl-networks.tfvars `
    # --var-file=../config/all/ip-lists/akamai-ip-lists.tfvars `
    # -var="subscription_id=$($subscriptionId)" `
    # -var="hub_subscription_id=$hubSubscriptionId" `
    # -var="team=$($teamName)" `
    # -var="environment=$($environment)" `
    # -var="spokes_as_json=$(($landingZone.spokes | ConvertTo-Json -Depth 10 -AsArray -Compress).Replace('"','\"'))" `
    # -var="instance_number=$($landingZone.'instance-number')" `
    # -var="team_group_name=$($team.group.name.ToLower())" `
    # -var="business_unit=$($landingZone.'business-unit'.ToLower())" `
    # -var="additional_team_group_roles=$(($null -eq $landingZone.'additional-team-roles' ? '[]' : ($landingZone.'additional-team-roles' | ConvertTo-Json -AsArray -Compress)).Replace('"','\"'))" | Out-File "report/plan-output/$($subscriptionName).tfplan"

switch ( $LASTEXITCODE ) {
    0 {
        $changes = "NO"
        $numberToAdd = "0"
        $numberToChange = "0"
        $numberToDestroy = "0" 
    }
    1 {
        $changes = "ERROR"
        $numberToAdd = "0"
        $numberToChange = "0"
        $numberToDestroy = "0"
    }
    2 {
        $changes = "YES"
        $planOutput = (grep 'Plan:' "report/plan-output/$($subscriptionName).tfplan").Split(' ')
        $numberToAdd = $planOutput[1]
        $numberToChange = $planOutput[4]
        $numberToDestroy = $planOutput[7]
    }
}
Write-Output "INFO: changes=$($changes), #add=$($numberToAdd), #change=$($numberToChange), #destroy=$($numberToDestroy)"
$landingZones.add(
    @(
        $subscriptionName,
        $environment, 
        "<a href=`"../datasets/plan-output/$($subscriptionName).tfplan`">$($changes)</a>",
        $numberToAdd,
        $numberToChange,
        $numberToDestroy
    )
) | out-null

# [System.Collections.ArrayList]$landingZones = @()
# # loop over all files in config directory
# mkdir -p report/plan-output
# $files = Get-ChildItem ./foundation/landingzone/config/$tenant
# foreach ($file in $files) {
#     Write-Output "-------"
#     $teamName = $file.name.Split('.')[0].ToLower()
#     Write-Output "INFO: teamName=$teamName"
#     $team = (yq -o=json '.' $file | ConvertFrom-Json)
#     foreach ($environment in $team.'landing-zones'.PSObject.Properties.Name) {
#         # echo the environment
#         Write-Output "INFO: environment=$environment"
#         foreach ($landingZone in $team.'landing-zones'."$environment") {
#             # echo the landingzone
#             Write-Output "INFO: landingZone=$landingZone"
#             $subscriptionName = "$($landingZone.'business-unit')-$($teamName)-$($environment)-$($landingZone.'instance-number')"
#             # echo the subscription
#             Write-Output "INFO: subscriptionName=$subscriptionName"
#             $subscriptionId = ($subscriptionTags | Where-Object {$_.name -eq $subscriptionName}).subscriptionId
#             if (!$subscriptionId ) { 
#                 Write-Output "ERROR: subscriptionId '$subscriptionId' not found, skip this subscriptionId"
#             } else { 
#                 # echo the subscriptionId
#                 Write-Output "INFO: subscriptionId=$subscriptionId"
#                 $tags = ($subscriptionTags | Where-Object {$_.name -eq $subscriptionName}).tags

#                 Remove-Item -Recurse -Force -ErrorAction SilentlyContinue foundation/landingzone/terraform/.terraform
#                 terraform -chdir=foundation/landingzone/terraform init -lock=false `
#                     -backend-config="key=foundation/lz-$($subscriptionName).tfstate" `
#                     -backend-config="resource_group_name=$($Env:TF_STATE_RESOURCE_GROUP)" `
#                     -backend-config="storage_account_name=$($Env:TF_STATE_STORAGE)"

#                 terraform -chdir=foundation/landingzone/terraform plan -no-color -input=false -lock=false -detailed-exitcode `
#                     --var-file=environment-$($environment).tfvars `
#                     --var-file=tenant-$($tenant.ToLower()).tfvars `
#                     --var-file=../config/all/ip-lists/afkl-networks.tfvars `
#                     --var-file=../config/all/ip-lists/akamai-ip-lists.tfvars `
#                     -var="subscription_id=$($subscriptionId)" `
#                     -var="hub_subscription_id=$hubSubscriptionId" `
#                     -var="team=$($teamName)" `
#                     -var="environment=$($environment)" `
#                     -var="spokes_as_json=$(($landingZone.spokes | ConvertTo-Json -Depth 10 -AsArray -Compress).Replace('"','\"'))" `
#                     -var="instance_number=$($landingZone.'instance-number')" `
#                     -var="team_group_name=$($team.group.name.ToLower())" `
#                     -var="business_unit=$($landingZone.'business-unit'.ToLower())" `
#                     -var="additional_team_group_roles=$(($null -eq $landingZone.'additional-team-roles' ? '[]' : ($landingZone.'additional-team-roles' | ConvertTo-Json -AsArray -Compress)).Replace('"','\"'))" | Out-File "report/plan-output/$($subscriptionName).tfplan"

#                 switch ( $LASTEXITCODE ) {
#                     0 {
#                         $changes = "NO"
#                         $numberToAdd = "0"
#                         $numberToChange = "0"
#                         $numberToDestroy = "0" 
#                     }
#                     1 {
#                         $changes = "ERROR"
#                         $numberToAdd = "0"
#                         $numberToChange = "0"
#                         $numberToDestroy = "0"
#                     }
#                     2 {
#                         $changes = "YES"
#                         $planOutput = (grep 'Plan:' "report/plan-output/$($subscriptionName).tfplan").Split(' ')
#                         $numberToAdd = $planOutput[1]
#                         $numberToChange = $planOutput[4]
#                         $numberToDestroy = $planOutput[7]
#                     }
#                 }
#                 Write-Output "INFO: changes=$($changes), #add=$($numberToAdd), #change=$($numberToChange), #destroy=$($numberToDestroy)"
#                 $landingZones.add(
#                     @(
#                         $subscriptionName,
#                         $environment, 
#                         $landingZone.update.channel,
#                         $landingZone.update.batch,
#                         $tags.foundationversiontarget,
#                         $tags.foundationversionapplied,
#                         $tags.configversiontarget,
#                         $tags.configversionapplied,
#                         "<a href=`"../datasets/plan-output/$($subscriptionName).tfplan`">$($changes)</a>",
#                         $numberToAdd,
#                         $numberToChange,
#                         $numberToDestroy
#                     )
#                 ) | out-null
#             } # end if-else subscriptionId
#         } # end foreach landingZone
#     } # end foreach environment
# } # end foreach file

# create the output file
Write-Output "{`"data`": $($landingZones | Sort-Object { $_.'update-channel' }, { $_.'update-batch' }, { $_.'landing-zone' } | ConvertTo-Json -Compress) }" | Out-File -FilePath $datafile
Write-Output "-------"
Write-Host "INFO: json written to file $datafile"

## Generate the metadata file for the report
$scripName = $MyInvocation.MyCommand.Name
$datetime = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'W. Europe Standard Time')
$datetime_cet = Get-Date -Date $datetime -Format "yyyy-MM-dd HH:mm:ss"
Write-Output "Generated by ${ghRepository}:$scripName on $datetime_cet CET" | Out-File -FilePath $metafile
Write-Output "Run by $ghWorkflow, triggert by $ghEvent" | Out-File -Append -FilePath $metafile
Write-Host "INFO: metadata written to file $metafile"

if (((Get-Item $datafile).length) -lt 1KB) {
    Write-Host "ERROR: json datafile ($datafile) does not contain all data, somewhere an error must have occurred"
    exit 99
}