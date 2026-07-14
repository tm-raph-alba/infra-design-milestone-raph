# backend.tf
# Remote state configuration for Terraform.
# This backend stores the state file in Azure Storage so CI/CD and local runs share the same deployment state.
# Create the storage account and container once before running terraform init for the first time.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-capstone-backend-raph"
    storage_account_name = "straphtfstate001"
    container_name       = "tfstate"
    key                  = "infra-design-milestone.tfstate"
  }
}