output "resource_group_name" {
  description = "Created Resource Group"
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "CReated Resource Group Location"
  value       = module.resource_group.location
}

output "resource_group_id" {
  description = "Created Resource Group ID"
  value       = module.resource_group.id

}

output "vnet_name" {
  description = "Created VNet name."
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "Created VNet ID."
  value       = module.network.vnet_id
}

output "aks_subnet_id" {
  description = "Created AKS subnet ID."
  value       = module.network.aks_subnet_id
}