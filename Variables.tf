# Azure Options
variable "azure_region" {
  default     = "centralus" # Use region shortname here as it's interpolated into the URLs
  description = "The location/region where the resources are created."
}

variable "azure_env" {
  default = "Dev"
  description = "This is the name of the environment tag, i.e. Dev, Test, etc."
}

variable "azure_rg_name" {
  default = "lab" # This will get a unique timestamp appended
  description = "Specify the name of the new resource group"
}

# Shared Options

variable "username" {
  default = "labadmin"
  description = "Admin username for all VMs"
}

variable "password" {
  default = "P@ssw0rd1234!"
  description = "Admin password for all VMs"
}

variable "vm_size" {
  default = "Standard_D4S_v3"
  description = "Specify the VM Size"
}

variable "source_address_prefix" {
  default = "*"
  description = "Specify source prefix i.e. 1.2.3.4/24. This restricts the network security group so only your systems can remotely access the resources. Prevents resources from being exposed directly to the Internet."
}

variable "hab_origin" {
  description = "Specify the package origin name"
}

variable "audit_pkg_name" {
  description = "Specify the name of your effortless audit package"
}

variable "infra_pkg_name" {
  description = "Specify the name of your effortless infra package"
}
