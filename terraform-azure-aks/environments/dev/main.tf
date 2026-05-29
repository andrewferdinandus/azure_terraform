module "resource_group" {
  source = "../../modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source = "../../modules/network"

  name                = var.vnet_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  address_space               = var.vnet_address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes

  enable_nat_gateway                  = var.enable_nat_gateway
  nat_gateway_name                    = var.nat_gateway_name
  nat_gateway_public_ip_name          = var.nat_gateway_public_ip_name
  nat_gateway_idle_timeout_in_minutes = var.nat_gateway_idle_timeout_in_minutes

  tags = var.tags
}

module "aks_identity" {
  source = "../../modules/managed-identity"

  name                = var.aks_identity_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  tags = var.tags
}

module "aks_network_contributor_role" {
  source = "../../modules/role-assignments"

  principal_id         = module.aks_identity.principal_id
  scope                = module.network.vnet_id
  role_definition_name = "Network Contributor"
}

module "aks" {
  source = "../../modules/aks"

  name                = var.aks_cluster_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version      = var.aks_kubernetes_version
  private_cluster_enabled = var.aks_private_cluster_enabled

  subnet_id    = module.network.aks_subnet_id
  identity_ids = [module.aks_identity.id]

  system_node_pool_name       = var.system_node_pool_name
  system_node_vm_size         = var.system_node_vm_size
  system_node_min_count       = var.system_node_min_count
  system_node_max_count       = var.system_node_max_count
  system_node_os_disk_size_gb = var.system_node_os_disk_size_gb

  user_node_pool_name       = var.user_node_pool_name
  user_node_vm_size         = var.user_node_vm_size
  user_node_min_count       = var.user_node_min_count
  user_node_max_count       = var.user_node_max_count
  user_node_os_disk_size_gb = var.user_node_os_disk_size_gb
  user_node_labels          = var.user_node_labels

  tags = var.tags

  depends_on = [
    module.aks_network_contributor_role
  ]
}

module "acr" {
  source = "../../modules/acr"

  enabled             = var.enable_acr
  name                = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  tags = var.tags
}

module "aks_acr_pull_role" {
  count  = var.enable_acr ? 1 : 0
  source = "../../modules/role-assignments"

  principal_id         = module.aks.kubelet_identity_object_id
  scope                = module.acr.id
  role_definition_name = "AcrPull"

  depends_on = [
    module.aks,
    module.acr
  ]
}