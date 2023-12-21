terraform {
  backend "local" {
    path = ".terraform/fileshare.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
  # skip_provider_registration = true
  subscription_id = "SUBSCRIPTION_ID"
  # subscription_id = "SUBSCRIPTION_ID"
  tenant_id     = "TENANT_ID"
  client_id     = "CLIENT_ID"
  client_secret = "SPN_SECRET"
}
