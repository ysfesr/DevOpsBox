variable "resource_group_name" {
  description = "The name of the Azure Resource Group where the AKS cluster and ACR will be created."
  type        = string
  default     = "AKS-resource-group"
}

variable "location" {
  description = "The Azure region where the AKS cluster and ACR will be deployed."
  type        = string
  default     = "West Europe"
}

variable "cluster_name" {
  description = "The name of the AKS cluster to be created."
  type        = string
  default     = "aks-cluster"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to be used for the AKS cluster."
  type        = string
  default     = "1.26.3"
}

variable "worker" {
  description = "The number of worker nodes to be provisioned in the AKS cluster."
  type        = number
  default     = 3
}

variable "acr_name" {
  description = "The name of the Azure Container Registry (ACR) to be created."
  type        = string
}
