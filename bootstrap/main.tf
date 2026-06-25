# bootstrap/main.tf
#
# This is the ONE deliberate exception to "always use remote state" in this
# project. Bootstrap's job is to create the Storage Account that every other
# Terraform configuration in this repo (infra/, policies/) will use as its
# remote backend. Since that backend doesn't exist until this code runs,
# this configuration has nowhere remote to put ITS OWN state -- so it uses
# local state, applied once, and is rarely touched again afterward.
#
# This local state file is excluded from git via .gitignore (it can contain
# resource IDs and should be treated carefully, same as any other state).

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.95"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

# A short random suffix keeps the storage account name globally unique
# without requiring you to hand-pick and remember an available name.
resource "random_id" "suffix" {
  byte_length = 3
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-northwind-tfstate"
  location = "canadacentral"

  tags = {
    Project     = "northwind-iac"
    Environment = "shared"
    Owner       = "satyadeep"
    Purpose     = "terraform-state-backend"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                = "stnorthwindtf${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Explicit, not relied-upon-as-default: state files can contain secrets,
  # so this account is held to the same bar as a PII-handling resource.
  min_tls_version           = "TLS1_2"
  https_traffic_only_enabled = true

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Project     = "northwind-iac"
    Environment = "shared"
    Owner       = "satyadeep"
    Purpose     = "terraform-state-backend"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

output "resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}