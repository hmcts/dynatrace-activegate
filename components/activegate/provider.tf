terraform {
  required_version = ">= 0.13.0"

  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.88.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias = "law_nonprod"
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

provider "azurerm" {
  alias = "law_prod"
  features {}
  subscription_id = "8999dec3-0104-4a27-94ee-6588559729d1"
}

provider "azurerm" {
  alias = "soc"
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias = "ptl"
  features {}
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "azurerm" {
  subscription_id            = local.hub["sbox"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-sbox"
}

provider "azurerm" {
  subscription_id            = local.hub["nonprod"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-nonprod"
}

provider "azurerm" {
  subscription_id            = local.hub["prod"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-prod"
}

provider "azurerm" {
  alias = "cnp"
  features {}
  subscription_id = var.cnp_vault_sub
}

provider "azurerm" {
  features {}
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  alias           = "DTS-CFTPTL-INTSVC"
}

provider "azurerm" {
  alias = "dcr"
  skip_provider_registration = "true"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.cnp_vault_sub
}
