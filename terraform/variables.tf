# variables.tf 
# Variables file for Terraform.

variable "admin_source_ip" {
    description = "CIDR allowed to SSH into the app VM. "
    type        = string
}

variable "db_admin_password" {
    description = "PostgreSQL admin password."
    type        = string
}

variable "vm_ssh_public_key" {
    description = "SSH public key for the VM."
    type        = string
}