# variables.tf 
# Required input variables for the deployment.
# These values are expected to be supplied through terraform.tfvars or environment secrets.

variable "admin_source_ip" {
    description = "CIDR allowed to SSH into the app VM. "
    type        = string
}

variable "db_admin_password" {
  description = "Administrator password for the PostgreSQL Flexible Server. Use a strong password with at least 16 characters."
  type        = string
  sensitive   = true
}

variable "vm_ssh_public_key" {
  description = "SSH public key that will be installed on the Linux VM for administrative access."
  type        = string
}