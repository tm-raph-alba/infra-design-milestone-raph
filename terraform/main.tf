# main.tf 
# All application infrastructure stays in this resource group.
# Terraform state backend lives in a seperate resource group (rg-capstone-backend-raph)
# to avoid accidental deletion of the state file.

resource "azurerm_resource_group" "main" {
    name            = "rg-capstone-raph"
    location        = "southeastasia"

    tags = {
        project     = "infra-design-milestone"
        environment = "single"
    }
}