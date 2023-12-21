terraform {
  backend "local" {
    path = ".terraform/rg.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.39.1"
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
  tenant_id       = "TENANT_ID"
  client_id       = "CLIENT_ID"
  client_secret   = "0tl8Q~MjQO01B9RHmV_ike1mAd4yxhXF7BX0laHh"
}
