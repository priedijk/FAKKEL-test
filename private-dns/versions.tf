terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod-weu-001"
    storage_account_name = "sttfstate15419"
    container_name       = "tfstate"
    key                  = "foundation/privatedns.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.81.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
  features {}
}
