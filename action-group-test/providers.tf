terraform {
  backend "azurerm" {
    resource_group_name  = "tffakkeltest"
    storage_account_name = "tffakkeltest"
    container_name       = "tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.18.0"
    }
  }
}

provider "azurerm" {
  features {}
}