# testing
eventhub_namespace_shared = {
  "nonprod" = {
    location       = "northeurope",
    prefix         = "001"
    instance_count = 5
    test           = true
    test1          = 5
  },
  "prod" = {
    location       = "northeurope",
    prefix         = "010"
    instance_count = 5
    test           = null
    test1          = null
  }
}

# # stable 2
# eventhub_namespace_shared = {
#   "environments" = {
#     "nonprod" = {
#       location       = "northeurope",
#       prefix         = "001"
#       instance_count = 5
#     },
#     "prod" = {
#       location       = "northeurope",
#       prefix         = "010"
#       instance_count = 5
#     }
#   }
# }


# # stable
# eventhub_namespace_shared = {
#   "001" = {
#     # "environments" = {
#     nonprod = {
#       location = "northeurope",
#       prefix   = "001"
#     },
#     prod = {
#       location = "northeurope",
#       prefix   = "010"
#     }
#   }
#   # }
# }

# multiple lines
# eventhub_namespace_shared = {
#   "001" = {
#     "product" = {
#       "shared" = {
#         "environments" = {
#           nonprod = {
#             location = "northeurope",
#             prefix   = "001"
#           },
#           prod = {
#             location = "northeurope",
#             prefix   = "010"
#           }
#         }
#       }
#     }
#   }
# }

##### logic var for logic.tf

# gh_users = {
#     user_one = {
#         username = "user1",
#         main_role = "member",
#         teams  = {
#             team1 = {
#                 role = "member"
#             }
#         }
#     },
#     user_two = {
#         username  = "user2",
#         main_role = "admin",
#         teams     = {
#             team1 = {
#                 role = "maintainer"
#             },
#            team2 = {
#                role = "maintainer"
#            }
#         }
#     }
# }
