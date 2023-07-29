variable "location" {
  type        = string
  description = "Azure region for the resource group"
  default     = "westeurope"
}

variable "network-vnet-cidr" {
  type        = string
  description = "The CIDR of the network VNET"
  default     = "10.0.0.0/16"
}
variable "network-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
  default     = "10.0.1.0/24"
}

variable "jenkins_vm_size" {
  type        = string
  description = "The size of the Jenkins VM"
  default     = "Standard_DS2_v2"
}

variable "linux_admin_username" {
  type        = string
  description = "Username for Virtual Machine administrator account"
	sensitive 	= true
	nullable		= false
}
variable "linux_admin_password" {
  type        = string
  description = "Password for Virtual Machine administrator account"
	sensitive		= true
	nullable		= false
}
