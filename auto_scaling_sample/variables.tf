variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "project_env" {
  type        = string
  description = "The environment (dev, stage, prod)"
}

variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network"
}

variable "subnet_name" {
  type        = string
  description = "The name of the Subnet"
}

variable "security_group" {
  type        = string
  description = "The name of the Security Group"
}

variable "public_ip" {
  type = string
  description = "The name of Public IP"

}

variable "resource_skus" {
  type = object({
    pip = string
    lb  = string
    nat_ip = string
  })
}

variable "resource_zones" {
  type = object({
    pip = list(string)
    nat_pip = list(string)

  })
}

variable "resource_alloc_methods" {
  type = object({
    pip = string
    nat_ip = string

  })
}

variable "lb_name" {
  type = string
  description = "The name of Load Balancer"

}

variable "lb_frontend_ip" {
  type = string
  description = "The name of LB Fronend IP"

}

variable "lb_backend_pool" {
  type = string
  description = "The name of LB Backend Pool"

}

variable "nat_public_ip" {
  type = string
  description = "The name of NAT Public IP"

}

variable "nat_gw" {
  type = string
  description = "The name of NAT GW"

}