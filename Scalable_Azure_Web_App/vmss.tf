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
  sku_name                    = local.selected_vm_size
  instances                   = var.vmss_instance_count
  platform_fault_domain_count = 1     # For zonal deployments
  zones                       = var.resource_zones.vmss
  

  #custom_data_base64encode = base64encode(file("${path.module}/user-data.sh"))
  extension {
  name                 = "install-apache-v3"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
  commandToExecute = "apt-get update -y && apt-get install -y apache2 php php-curl libapache2-mod-php php-mysql jq && rm -f /var/www/html/index.html && cd /var/www/html && curl -o index.php https://raw.githubusercontent.com/Azure/vm-scale-sets/master/terraform/terraform-tutorial/app/index.php && systemctl enable apache2 && systemctl restart apache2"
  })
}

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
  
  #Use Managed Storage to view boot logs
  boot_diagnostics {
    storage_account_uri = ""
  }

  # Ignore changes to the instances property, so that the VMSS is not recreated when the number of instances is changed
  lifecycle {
    ignore_changes = [
      instances
    ]
  }

  tags = local.common_tags

}

#Auto scaling rules (CPU < 10 scale-in, CPU > 80 scale-out)
resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "vmss-autoscale"
  resource_group_name = azurerm_resource_group.proj_1.name
  location            = azurerm_resource_group.proj_1.location
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.proj_vmss.id

  profile {
    name = "defaultProfile"
    capacity {
      default = var.vmss_instance_count
      minimum = 1
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.proj_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.proj_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    
  }
  notification {
        email {
        #send_to_subscription_administrator    = true
        #send_to_subscription_co_administrator = true
        custom_emails                         = ["andrew.ferdinandus@gmail.com"]
        }
    }
}



  