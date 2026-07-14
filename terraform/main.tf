# main.tf
# Core application resource group.
# This file creates the main resource group that hosts the VM, networking, and database resources.
# The Terraform state backend is intentionally kept in a separate resource group so it is not removed by accident.

resource "azurerm_resource_group" "main" {
    name            = "rg-capstone-raph"
    location        = "southeastasia"

    tags = {
        project     = "infra-design-milestone"
        environment = "single"
    }
}