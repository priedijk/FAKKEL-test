terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-FAKKEL-test"
    storage_account_name = "tfstatefakkeltest"
    container_name       = "tfstatefakkeltest"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.99.0"
    }
  }
}

provider "azurerm" {
  features {}
}