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
    vmss = string
    ossku   = string
  })
}

variable "resource_zones" {
  type = object({
    pip = list(string)
    nat_pip = list(string)
    vmss = list(string)

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

variable "proj_vmss" {
  type = string
  description = "The name of VMSS"

}

variable "vmss_instance_count" {
  type        = number
  description = "The number of virtual machines in the Scale Set"
  default     = 3
}


variable "os_publisher" {
  type = string
  description = "The name OS Publisher"

}

variable "os_offer" {
  type = string
  description = "OS Offer Type"
}

variable "os_version" {
  type = string
  description = "OS Version"
}

variable "os_storage" {
  type = string
  description = "OS Hard Disk Type"
}

variable "os_caching" {
  type = string
  description = "OS Disk Caching Method"
}

variable "vmss_ip" {
  type = string
  description = "VMSS NIC Name"
}

variable "vmipconfig" {
  type = string
  description = "VMSS Ip Configuration"
}