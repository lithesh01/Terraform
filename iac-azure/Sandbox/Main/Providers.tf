terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc        = true
}

provider "azurerm" {
  alias           = "external"
  subscription_id = var.external_subscription_id
  features {}
  use_oidc        = true
}
