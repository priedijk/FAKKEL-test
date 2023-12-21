# https://discuss.hashicorp.com/t/create-new-map-from-a-nested-structure-with-for-loops/9441

# locals {
#   team_members = flatten([
#     for user, user_info in var.flatten : [
#       for team, team_data in user_info.teams : {
#         team_name = team
#         user_name = user
#         username  = user_info.username
#         role      = team_data.role
#       }
#     ]
#   ])
# }

# resource "azurerm_resource_group" "rg-logic" {
#   for_each = {
#     for tm in local.team_members : "${tm.team_name}-${tm.user_name}" => tm
#   }
#   name     = "rg-test-${each.value.team_name}-${each.value.username}-${each.value.role}"
#   location = "northeurope"
# }
