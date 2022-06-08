terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.99.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "e2c1b56d-a413-43fc-b1e2-f73e153c05ad"
  tenant_id         = "de4f794e-ddec-4aed-a207-ba27c0314337"
  client_id         = "073dd519-4fd5-4867-aac5-7f01827bec6f"
  client_secret     = "olG8Q~xRL3_Qj4uqo21KHirtpSdM_y4Qes13YcFY"
}