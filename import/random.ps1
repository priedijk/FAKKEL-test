[CmdletBinding()]
param(
    [String] [Parameter (Mandatory = $true)]  $subscription,
    [String] [Parameter (Mandatory = $true)]  $location,
    [String] [Parameter (Mandatory = $true)]  $terraformdir
)


terraform -chdir="${terraformdir}" import random_id.import "VtU"
