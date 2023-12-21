# Stable Separated namepace and eventhubs
# locals {
#   eventhubs = flatten([
#     for instances, instance_data in var.eventhub_namespace_shared : [
#       for environment, environment_data in instance_data : {
#         environment     = environment
#         instance_number = instances
#         location        = environment_data.location
#       }
#     ]
#   ])
# }
# # stable
# resource "azurerm_resource_group" "rg" {
#   for_each = { for instance in local.eventhubs : "${instance.environment}-${instance.instance_number}" => instance }
#   name     = "rg-${each.value.environment}-${each.value.instance_number}"
#   location = each.value.location
#   tags = {
#     "key"      = "${each.key}"
#     "env"      = "${each.value.environment}"
#     "location" = "${each.value.location}"
#     "eventhub" = "eventhub-${each.value.environment}-${each.value.instance_number}"
#   }
# }

locals {
  nonprod_count    = 1
  prod_count       = 1
  applog_eventhubs = ["001", "002"]
  applogs = merge([
    for environments, environment_data in var.eventhub_namespace_shared : {
      for instance in local.applog_eventhubs :
      "${environment_data.location}_${instance}" => {
        location = environment_data.location
        instance = instance
      }
    }
  ]...)

  eventhubs = flatten([
    for environments, environment_data in var.eventhub_namespace_shared : [
      for instance in range(1, (environments == "prod" ? local.prod_count : local.nonprod_count) + 1) : {
        environment = environments
        # instance_number = instances
        location              = environment_data.location
        number                = environment_data.instance_count
        format                = "${format("%03d", instance)}"
        endpoint_abbreviation = environments == "prod" ? "pr" : "np"
        test                  = environment_data.test
        test1                 = environment_data.test1
      }
    ]
  ])
}

resource "azurerm_resource_group" "test-logic-for" {
  for_each = local.applogs
  name     = "rg-test-${each.key}-${each.value.instance}"
  location = "westeurope"
}

# resource "azurerm_resource_group" "test-logic-for" {
#   for_each = { for instance in local.eventhubs : 
#     for instance in toset(local.applog_eventhubs) : "${instance.key}" => instance }
#   name     = "rg-test-${each.key}-${instance.key}"
#   location = "westeurope"
# }


# resource "azurerm_resource_group" "rg" {
#   for_each = { for instance in local.eventhubs : "${instance.environment}-${instance.format}" => instance }
#   name     = "rg-${each.value.environment}-${each.value.format}"
#   location = each.value.location
#   tags = {
#     "key"                   = "${each.key}"
#     "env"                   = "${each.value.environment}"
#     "location"              = "${each.value.location}"
#     "eventhub"              = "eventhub-${each.value.environment}-${each.value.format}"
#     "endpoint-abbreviation" = "${each.value.endpoint_abbreviation}"
#     "test"                  = "${each.value.test}"
#     "test1"                 = "${each.value.test1}"
#   }
# }

# resource "azurerm_resource_group" "test-logic" {
#   for_each = toset(local.applog_eventhubs)
#   name     = "rg-test-${each.key}"
#   location = "westeurope"
# }


# ### for stable 2
# locals {
#   nonprod_count = 2
#   prod_count    = 1

#   eventhubs = flatten([
#     for instances, instance_data in var.eventhub_namespace_shared : [
#       for environment, environment_data in instance_data : [
#         for i in range(1, (environment == "prod" ? local.prod_count : local.nonprod_count) + 1) : {
#           environment     = environment
#           instance_number = instances
#           location        = environment_data.location
#           number          = environment_data.instance_count
#           format          = "${format("%03d", i)}"
#         }
#       ]
#     ]
#   ])
# }

# resource "azurerm_resource_group" "rg" {
#   for_each = { for instance in local.eventhubs : "${instance.environment}-${instance.format}" => instance }
#   name     = "rg-${each.value.environment}-${each.value.format}"
#   location = each.value.location
#   tags = {
#     "key"      = "${each.key}"
#     "env"      = "${each.value.environment}"
#     "location" = "${each.value.location}"
#     "eventhub" = "eventhub-${each.value.environment}-${each.value.format}"
#   }
# }

