# variables.tf 
# Variables file for Terraform.

variable "admin_source_ip" {
    description = "CIDR allowed to SSH into the app VM."
    type        = string
}