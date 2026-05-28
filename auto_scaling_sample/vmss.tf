#Generate SSH Key
resource "tls_private_key" "vmss_ssh_key" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

#Save the Key to your Device
resource "local_file" "private_key_file" {
  content  = tls_private_key.vmss_ssh_key.private_key_pem
  filename = "${path.module}/vmss_key.pem"
  file_permission = "0600"
}

resource "azurerm_orchestrated_virtual_machine_scale_set" "proj_vmss" {
  name                        = var.proj_vmss
  resource_group_name         = azurerm_resource_group.proj_1.name
  location                    = azurerm_resource_group.proj_1.location
  sku_name                    = var.resource_skus.vmss
  instances                   = var.vmss_instance_count
  platform_fault_domain_count = 1     # For zonal deployments, this must be set to 1
  zones                       = var.resource_zones.vmss

  user_data_base64 = base64encode(file("user-data.sh"))
  os_profile {
    linux_configuration {
      disable_password_authentication = true
      admin_username                  = "azureuser"
      admin_ssh_key {
        username   = "azureuser"
        public_key = tls_private_key.vmss_ssh_key.public_key_openssh
      }
    }
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.resource_skus.ossku
    version   = var.os_version
  }

  os_disk {
    storage_account_type = var.os_storage
    caching              = var.os_caching
  }

  network_interface {
    name                          = var.vmss_ip
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = var.vmipconfig
      primary                                = true
      subnet_id                              = azurerm_subnet.priv_1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id] #LB registers vmss IPs in their pool
    }
  }
  
  #WUse Managed Storage to view boot logs
  boot_diagnostics {
    storage_account_uri = ""
  }

  # Ignore changes to the instances property, so that the VMSS is not recreated when the number of instances is changed
  lifecycle {
    ignore_changes = [
      instances
    ]
  }

}



  