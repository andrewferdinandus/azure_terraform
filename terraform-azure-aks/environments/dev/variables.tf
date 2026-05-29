variable "resource_group_name" {
  description = "Resource Group for the Dev Environment"
  type        = string
}

variable "location" {
  description = "Azure Region for the Dev Environment"
  type        = string
}

variable "tags" {
  description = "Common Tags for the Dev Environment"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "Name of the dev virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the dev virtual network."
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet."
  type        = string
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefixes for the AKS subnet."
  type        = list(string)
}

variable "aks_identity_name" {
  description = "Name of the AKS User Assigned Managed Identity."
  type        = string
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version for AKS. Null means Azure default."
  type        = string
  default     = null
}

variable "aks_private_cluster_enabled" {
  description = "Whether AKS private cluster is enabled."
  type        = bool
  default     = false
}

variable "system_node_pool_name" {
  description = "Name of the AKS system node pool."
  type        = string
}

variable "system_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
}

variable "system_node_min_count" {
  description = "Minimum system node count."
  type        = number
}

variable "system_node_max_count" {
  description = "Maximum system node count."
  type        = number
}

variable "system_node_os_disk_size_gb" {
  description = "OS disk size for system node pool."
  type        = number
}