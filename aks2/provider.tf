terraform {
  backend "azurerm" {
    resource_group_name  = "tffakkeltest"
    storage_account_name = "tffakkeltest"
    container_name       = "tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "random_id" "nr" {
  byte_length = 4
}
