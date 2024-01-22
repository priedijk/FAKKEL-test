# Github action to generate a SAS token for a Storageaccount.

## Contributors

- Owner -
- Contributors - Feel free

### Description

This github action allows teams to generate a SAS token for a Fileshare or Blob container within a Storage account. The Storage Account has to be in your landing zone.

The following SAS tokens can be generated:
- Read token with a maximum validity of 1 year
- Write token with a maximum validity of 1 month   

### Mandatory login

Before using this action, it's mandatory to login to azure (see [usage](#usage)).

### Mandatory password masking

Before using this action, it's mandatory to mask the password of the zip file (see [usage](#usage)). The password will not be visible in the logs.

#### Password requirements:
- Must be at least 12 characters
- Must contain at least one lowercase letter
- Must contain at least one uppercase letter
- Must contain at least one special character
  - Special characters can only be one of !@#$%^&*?
- Must contain at least one number

## Parameters

| Input | Description  | Required | Default |
| --- | --- | --- | --- |
| storageaccount | The Storage Account to create a SAS token for. | yes | - |
| fileshare | The Fileshare to create a SAS token for. | one of | - |
| container | The Blob container to create a SAS token for. | one of | - |
| password | The Password to use for the SAS token zip file. | yes | - |
| access | The type access the SAS token requires. Either `read` or `write` | yes | `read` |
| validity | The validity of the SAS token in days. | yes | `7` |

## Usage

This is an example of using this github action. You can reuse, adapt or create your own workflow
```yaml

on:
  workflow_dispatch:
    inputs:
      storageaccount:
        description: "The Storage Account to create a SAS token for."
        type: string
        default: ''
      fileshare:
        description: "The Fileshare to create a SAS token for."
        type: string
        default: ''
      container:
        description: "The Blob container to create a SAS token for."
        type: string
        default: ''
      password:
        description: "The Password to use for the SAS token zip file."
        type: string
        default: ''
      access:
        description: "The access the SAS token should have."
        type: choice
        options:
          - 'read'
          - 'write'
      validity:
        description: "The validity of the SAS token in days."
        type: string
        default: '7'

permissions:
  id-token: write
  contents: read

name: Generate SAS token
run-name: Generate SAS token | ${{ inputs.storageaccount }} | ${{ inputs.fileshare }} ${{ inputs.container }} | ${{ inputs.access }}

jobs:
  generate-sas-token:
    environment: cae
    runs-on: ["self-hosted","linux"]
    steps:

    - name: Mask password
      run: |
        PASSWORD=$(jq -r '.inputs.password' $GITHUB_EVENT_PATH)
        echo ::add-mask::$PASSWORD
        
    - name: Azure - Login
      uses: azure/login@v1
      with:
          client-id: ${{ vars.AZURE_CLIENT_ID }}
          tenant-id: ${{ vars.AZURE_TENANT_ID }}
          subscription-id: ${{ vars.AZURE_SUBSCRIPTION_ID }}

    - name: Generate SAS token
      uses: GITHUB ORG/actions-sas-token-create@v1.0.0
      with:
        storageaccount: ${{ inputs.storageaccount }}
        fileshare: ${{ inputs.fileshare }}
        container: ${{ inputs.container }}
        password: ${{ inputs.password }}
        access: ${{ inputs.access }}
        validity: ${{ inputs.validity }}
```
## Documentation
Please see for how to use the SAS token [documentation](Documentation).
