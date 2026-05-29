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