terraform {
    backend "azurerm" {
        resource_group_name  = "rg-capstone-backend-raph"
        storage_account_name = "straphtfstate001"
        container_name       = "tfstate"
        key                  = "infra-design-milestone.tfstate"
    }
}