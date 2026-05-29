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

output "aks_identity_id" {
  description = "AKS Managed Identity resource ID."
  value       = module.aks_identity.id
}

output "aks_identity_principal_id" {
  description = "AKS Managed Identity principal ID."
  value       = module.aks_identity.principal_id
}

output "aks_identity_client_id" {
  description = "AKS Managed Identity client ID."
  value       = module.aks_identity.client_id
}

output "aks_network_contributor_role_assignment_id" {
  description = "AKS identity Network Contributor role assignment ID."
  value       = module.aks_network_contributor_role.id
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.aks.name
}

output "aks_cluster_id" {
  description = "AKS cluster ID."
  value       = module.aks.id
}

output "aks_cluster_fqdn" {
  description = "AKS cluster FQDN."
  value       = module.aks.fqdn
}

output "user_node_pool_id" {
  description = "AKS user node pool ID."
  value       = module.aks.user_node_pool_id
}

output "user_node_pool_name" {
  description = "AKS user node pool name."
  value       = module.aks.user_node_pool_name
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = module.network.nat_gateway_id
}

output "nat_gateway_public_ip_address" {
  description = "NAT Gateway outbound public IP address."
  value       = module.network.nat_gateway_public_ip_address
}