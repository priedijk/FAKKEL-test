terraform {
  backend "azurerm" {
    resource_group_name  = "tfstatetestfakkel"
    storage_account_name = "tfstatetestfakkel"
    container_name       = "tfstate"
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
}
