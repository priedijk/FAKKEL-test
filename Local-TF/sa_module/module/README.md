# Advanced Automation - Terraform - Azure Storage Account
<p style="text-align:center;"><tt>v1.9.0</tt></p>

This module allows you to create an Azure Storage Account of various types, SKUs and replication options.

Check **[Confluence] (documentation page)** for more information.

## Prerequisites
This module requires:
- Terraform provider `azurerm` with **minimum** version of `3.48.0`. The AzureRM module contains a version constraint of `>= 3.48.0`.
- Terraform version with minimum version of `1.2.1`.

## Importance Notice
If face the issue "Operation `purge` is not allowed because purge protection is enabled for this Vault". Please add the following Terraform configuration for reference:
```hcl
provider "azurerm" {
  ...
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  ...
}
```

## Usage
> **Notice:** Must be careful for any parameter change as it can lead to a resource re-creation. For example, the parameter can be re-created as `resource_group_name`, `application`, `environment`, `account_tier`, `cmk_key_type`.
- Check Hashicorp docs if changing a parameter can lead to resource re-creation or not.
- Check the plan output to verify it matches the expectation before run apply.

An example of how to use this module with reference to Terraform Enterprise Registry:
```terraform
module "storageaccount" {
  source  = "terraform-organization/storageaccount/azure"
  version = "1.9.0"

  # These values need to be input by user:
  resource_group_name = "rg-app-name"
  application         = "advauto"
  environment         = "dev"

  # These values need to be input to use Private endpoint
  blob_container_names = ["dev"]
}
```

The above definition will create a standard Storage Account V2 named `st<application><env><name_suffix>` in Resource Group `rg-app-name`, with replication option of `Zone-Redundant Storage` or `ZRS`.

In the above example, some variables are not defined and they take default values. If you want to override the default value, explicitly define that corresponding variable. Refer to the table in the next section.

Notice that `<name_suffix>` is a randomly-generated alphanumeric string of 8 characters. This is to ensure that the name of App Service is unique each time a new resource is created.

## **Resource naming convention**
Resource created via this module will have a name following this pattern:
`st<application><env><name_suffix>`.

With:
- `<application>` as a user-input variable. See the section [**Variables**](#application) below for more information.
- `<env>` specifies the environment to which the Linux Web App belongs. See the section [**Variables**](#environment) below for more information
- `<name_suffix>` is a randomly-generated alphanumeric string of 8 characters.

## **Resource locking**
For some critical resources such as Databases, Storage Account, etc... If user want to protect them from being deleted or re-created by mistake, please add the below example configuration of resource locking as a setting in the TF configuration file. If after that, user wants to destroy or force replacement of the database resource in purpose (ie decommission), please set flag `prevent_destroy = false`.

```
# Lock Storage account with trigger to storage_account_id and prevent_destroy set to true
resource "null_resource" "lock_storageaccount" {
  triggers = {
    azurerm_storage_account_id = module.storageaccount.id
  }
  lifecycle {
    prevent_destroy = true
  }
}
```

## **Variables**
This module accepts following input variables:
| Variable| Description | Data type | Default value | Changes to re-creation | Remark | 
|---------|-------------|-----------|---------------|------------------------|--------|
| `subnet_name` | The name of the Subnet where the private endpoint should exist. | `string`  | `DataSubnet` | Yes | This overwrites the default subnet for the private endpoints, only use this if you have a non-standard landingzone |
| `resource_group_name` | Declares the name of Resource Group to create Storage Account. | `string`  | n/a | Yes | |
| `application` | Specifies the application name that the Storage account, as part of naming convention pattern `st<application><env><name_suffix>`. The value of `<application>` is alphanumeric string and must not exceed 11 characters. Example: advautotest. | `string`  | n/a | Yes | |
| `environment` | Specifies the environment to which the Storage account belongs, as part of naming convention pattern `st<application><env><name_suffix>`. Possible values are: `prd`, `fve`, `vte`, `tre`, `npe`, `acp`, `cae`, `ite`, `dev`, `ete`. | `string`  | n/a | Yes | |
| `account_tier` | Declares the tier of Storage Account. | `string`  | `Standard` | Yes | Only use `Standard`. |
| `account_replication_type` | Declares the replication option of Storage Account. | `string` | `ZRS` | No | Accepts one of following: `LRS`, `GRS`, `RAGRS`, `ZRS`. |
| `account_kind` | Declares the type of Storage Account. | `string`  | `StorageV2` | No | Only use `StorageV2`. |
| `enable_https_traffic_only` | Boolean flag which forces HTTPS if enabled. | `bool` | `true` |  No | |
| `min_tls_version` | The minimum supported TLS version for the storage account | `string` | `TLS1_2` | No | |
| `point_in_time_restore_enabled` | Is Point-in-time restore for containers is enabled? If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. | `bool` | `false` | No | See the section [**Data Protection**](#data-protection) below for more information. |
| `restore_policy_days` | Specifies the number of days that the blob can be restored. | `number` | `13` | No | `restore_policy_days` must be less than `blob_soft_delete_retention_days`. See the section [**Data Protection**](#data-protection) below for more information. |
| `blob_soft_delete_enabled` | Is Blob delete retention policy is enabled? | `bool` | `false` | No | See the section [**Data Protection**](#data-protection) below for more information. |
| `blob_soft_delete_retention_days` | Specifies the number of days that the blob should be retained, between `1` and `365` days. | `number` | `14` | No | See the section [**Data Protection**](#data-protection) below for more information. |
| `container_soft_delete_enabled` | Is Container delete retention policy is enabled? | `bool` | `false` | No | |
| `container_soft_delete_retention_days` | Specifies the number of days that the container should be retained, between `1` and `365` days. | `number` | `14` |  No | |
| `versioning_enabled` | Is versioning enabled? | `bool` | `true` |  No | |
| `last_access_time_enabled` | Is the last access time based tracking enabled? | `bool` | `true` |  No | |
| `change_feed_enabled` | Is the blob service properties for change feed events enabled? | `bool` | `true` |  No | |
| `fileshare_soft_delete_enabled` | Is File Share delete retention policy is enabled? | `bool` | `true` |  No | |
| `fileshare_soft_delete_retention_days` | Specifies the number of days that the fileshare should be retained, between `1` and `365` days. | `number` | `7` |  No | |
| `blob_container_names` | Declares a list of Blob Storage Containers. | `list(string)` | `[]` | No | More info in the section below. |
| `queue_names` | Declares a list of Queues. | `list(string)` | `[]` | No | More info in the section below. |
| `table_names` | Declares a list of Tables. | `list(string)` | `[]` | No | More info in the section below. |
| `fileshare_names` | Declares a list of File shares. | `list(string)` | `[]` | No | More info in the section below. |
| `access_tier` | The access tier of the File Share. Possible values are Hot, Cool and TransactionOptimized, Premium. | `string` | `TransactionOptimized` | No | More info in the section below. |
| `enabled_protocol` | The protocol used for the share. Possible values are SMB and NFS. | `string` | `SMB` | No | More info in the section below. |
| `quota` | The maximum size of the share, in gigabytes. | `number` | `5120` | No | More info in the section below. |
| `secret_data` | Enable Customer-managed key data encryption. | `bool` | `false` |  No | |
| `cmk_key_type` | Specifies the Key Type to use for this Key Vault Key. Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM. Changing this forces a new resource to be created. | `string` | `RSA-HSM` |  Yes | |
| `cmk_key_size` | Specifies the Size of the RSA key to create in bytes. For example, 1024 or 2048. Note: This field is required if key_type is RSA or RSA-HSM. | `string` | `2048` |  No | |
| `custom_tags` | Specifies a list of key-value pairs to define additional Tags for the resource. | `map(string)` | `[]` | No | |
| `inherited_tags` | Defines a set of Tags that should be inherited from parental Subscription. | `list(string)` | `["owner", "cloudscope", "environment", "businessunit", "tenant"]` | No | Should not be modified or manually input, unless a different set of Tags is required. |

*Variables with a default value are optional.*

## **Outputs**
This module exposes following output values:
| Output names | Description | Data type |
|--------------|-------------|-----------|
| `id` | Azure resource ID of Storage Account | `string` |
| `name` | Name of Storage Account | `string` |
| `resource_group_name` | Name resource group of Storage Account | `string` |
| `primary_blob_endpoint` | Primary blob storage endpoint of Storage Account | `string` |
| `secondary_blob_endpoint` | Secondary blob storage endpoint of Storage Account | `string` |
| `blob_containers_ids` | A list of IDs of Blob Storage Containers inside the Storage Account | `list(string)` |
| `blob_containers_names` | A list of names of Blob Storage Containers inside the Storage Account | `list(string)` |
| `queues_ids` | A list of IDs of Storage queue inside the Storage Account | `list(string)` |
| `queues_names` | A list of names of Storage queue inside the Storage Account | `list(string)` |
| `tables_ids` | A list of IDs of Storage table inside the Storage Account | `list(string)` |
| `tables_names` | A list of names of Storage table inside the Storage Account | `list(string)` |
| `fileshares_ids` | A list of IDs of Storage File Share inside the Storage Account | `list(string)` |
| `fileshares_names` | A list of names of Storage File Share inside the Storage Account | `list(string)` |

### Using outputs in root module
This example shows how to refer to module's output value from root module:
```terraform
module "storageaccount" {
  source  = "terraform-organization/storageaccount/azure"
  version = "1.9.0"
}

output "sta_blob_container_ids" {
  value = module.storageaccount.blob_containers_ids
}
```

The output values will look like this:
```terraform
Outputs:

sta_blob_container_ids = [
  "https://st<application><env><name_suffix>.blob.core.windows.net/dev",
  "https://st<application><env><name_suffix>.blob.core.windows.net/staging",
  "https://st<application><env><name_suffix>.blob.core.windows.net/prod",
]
```

## **Tags inheritance**
By default, resources created via this module will have following Tags:
- `owner`
- `cloudscope`
- `environment`
- `businessunit`
- `tenant`

This module will try to look for the values of `owner`, `cloudscope`, `environment`, `businessunit`, `tenant` in the parental Subscription of provisioned Storage Account. If parental Subscription contains a Tag with Tag Name matches any of these, the corresponding Tag Value will also be copied down to the provisioned Storage Account; if any of these Tag Name is not found within the Tags of parental Subscription, an explicit value of `undefined` will be used for that not-found Tag on the provisioned Storage Account.

### Example
If Subscription `mySub` contains following Tags:

  | Tag Name | Tag Value |
  |----------|-----------|
  | `owner`  | `somebody`|
  | `cloudscope` | `public` |
  | `environment` | `development` |
  
then Storage Account provisioned within `mySub` will have following Tags:

  | Tag Name | Tag Value |
  |----------|-----------|
  | `owner`  | `somebody`|
  | `cloudscope` | `public` |
  | `environment` | `development` |
  | `businessunit` | `undefined` |
  | `tenant` | `undefined` |

## **Custom Tags**
The variable `custom_tags` allows users to add more Tags to created resource if needed. The value for this variable is a `map` of `strings` in Terraform configuration language.

For example:
```terraform
custom_tags = {
  "application" = "advautotest"
  "repository" = "advauto-tf-demo"
}
```
...will create two additional Tags for the resource as follow:
| Tag Name | Tag Value |
| -------- | --------- |
| `application` | `advautotest` |
| `repository` | `advauto-tf-demo` |

Notice that it can also be defined as a single-line input like this (with comma-separated syntax):
```terraform
custom_tags = {"application"="advautotest", "repository"="advauto-tf-demo"}
```

## **Subresource of Storage Account**
This module is able to create a Storage Account together with one or more Subresource:
| Variable | Description | Data type | Default value |
|----------|-------------|-----------|---------------|
| `blob_container_names` | Declares a list of Blob Storage Containers. | `list(string)` | `[]` |
| `queue_names` | Declares a list of Queues. | `list(string)` | `[]` |
| `table_names` | Declares a list of Tables. | `list(string)` | `[]` |
| `fileshare_names` | Declares a list of File shares. | `list(string)` | `[]` |

### Create one or more Subresource (Blob container, Queue, Table and File share)
The following HCL code create a Storage Account named `st<application><env><name_suffix>` with a Blob container, a Queue, a Table and a File share called `dev`:
```terraform
module "storageaccount" {
  source  = "terraform-organization/storageaccount/azure"
  version = "1.9.0"

  # These values need to be input by user:
  resource_group_name = "rg-app-name"
  application         = "advauto"
  environment         = "dev"

  # These values is optional if user want to create 1 Queue, 1 Table and 1 File share
  blob_container_names = ["dev"]
  queue_names          = ["dev"]
  table_names          = ["dev"]
  fileshare_names      = ["dev"]
}
```

The following HCL code create a Storage Account named `st<application><env><name_suffix>` with 3 Blob container, 3 Queues, 3 Tables and 3 File shares sequentially called `dev`, `staging` and `prod`:
```terraform
module "storageaccount" {
  source  = "terraform-organization/storageaccount/azure"
  version = "1.9.0"

  # These values need to be input by user:
  resource_group_name = "rg-app-name"
  application         = "advauto"
  environment         = "dev"

  # These values is optional if user want to create 3 Queues, 3 Tables and 3 File shares
  blob_container_names = ["dev", "staging", "prod"]
  queue_names          = ["dev", "staging", "prod"]
  table_names          = ["dev", "staging", "prod"]
  fileshare_names      = ["dev", "staging", "prod"]
}
```

## **Data Protection**
Data protection provides options for recovering your data when it is erroneously modified or deleted, there are some points that to be needed notice.
- To enable point-in-time restore for containers only set `point_in_time_restore_enabled` flag to `true`. Besides, soft delete for blobs via `blob_soft_delete_enabled` will be automatically enabled. The `restore_policy_days` variable of point-in-time restore for containers will defined `13` days and the `blob_soft_delete_retention_days` variable of soft delete for blobs will defined `14` days by default. *Note that, the value of the `restore_policy_days` must be less than the value of the `blob_soft_delete_retention_days`*. For example,
  - If users define a value for `restore_policy_days` without the `blob_soft_delete_retention_days`. The value of `restore_policy_days` is large than `blob_soft_delete_retention_days` (i.e, `blob_soft_delete_retention_days` to `14` days by default), then `restore_policy_days` to set `13` days automatically.
  - If users define a value for `blob_soft_delete_retention_days` without `restore_policy_days` (i.e, `restore_policy_days` to `13` days by default) . The value of `blob_soft_delete_retention_days` is less than `restore_policy_days`, then `restore_policy_days` to set `restore_policy_days` = `blob_soft_delete_retention_days` - 1. (i.e, `blob_soft_delete_retention_days` is 12 < `restore_policy_days` is 13 => `restore_policy_days` is 11).
- If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. That mean, the `point_in_time_restore_enabled` set to `true` that will override 2 variables `versioning_enabled` and `change_feed_enabled` and set them to `true` despite users define values for them to `false`.

## **Remarks**
- For Private Endpoint in Storage account, it will be created automaticially when it create Blob container, Queue, Table or File share.
- For Blob container, Queue, Table or File share, these resource will be created after 5 minutes (because it depend on Private Endpoint creation before). If Private Endpoint do not create, these resources also do not create.
- Starting from `v1.2.0` forward, resources created via this module will automatically have two more Tags: `module_name` indicates which module was used to create resources and `module_version` indicates which version of the module was used. This is a built-in feature update and nothing change in the way that module is consumed by users.
- A connection from your application to the storage account can be made, using the connection string or access key secret created in the landing zone's keyvault. Two secrets are created which use the following naming convention: `<storage_account_name>-connection_string` or `<storage_account_name>-access-key`.