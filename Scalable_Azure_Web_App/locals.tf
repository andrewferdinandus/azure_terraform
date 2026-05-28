locals {
  #Environment Map & Date
  vm_size_map = {
    dev   = "Standard_B2as_v2"
    prod  = "Standard_D2as_v5"
  }
  selected_vm_size = lookup(local.vm_size_map, var.project_env, "Standard_B2as_v2")
  
  #YYYY-MM-DD format
  modified_date = formatdate("YYYY-MM-DD", timestamp())

  common_tags = {
    environment = var.project_env
    modified_on = local.modified_date
  }

  #Dynamic Block Rules
  nsg_rules = [
    { name = "AllowHTTP", priority = 100, port = "80" },
    { name = "AllowHTTPS", priority = 101, port = "443" },
    { name = "AllowSSH", priority = 102, port = "22" }
  ]
}