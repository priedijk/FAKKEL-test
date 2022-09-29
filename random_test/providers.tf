terraform {
  backend "azurerm" {
    resource_group_name  = "tffakkeltest"
    storage_account_name = "tffakkeltest"
    container_name       = "tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
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