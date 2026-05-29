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