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