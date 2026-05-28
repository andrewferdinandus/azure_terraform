#Random name generator
resource "random_pet" "lb_hostname" {

}

#Resource Group
resource "azurerm_resource_group" "proj_1" {
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}

#Virtual Network (Vnet)
resource "azurerm_virtual_network" "proj_vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.proj_1.location
  resource_group_name = azurerm_resource_group.proj_1.name
  
  tags = local.common_tags
}

#Subnet ( A single Subnet)
resource "azurerm_subnet" "priv_1" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.proj_1.name
  virtual_network_name = azurerm_virtual_network.proj_vnet.name
  address_prefixes     = ["10.0.0.0/20"]

}

#Security Group and Rules
resource "azurerm_network_security_group" "sec_gr_1" {
  name                = var.security_group
  location            = azurerm_resource_group.proj_1.location
  resource_group_name = azurerm_resource_group.proj_1.name

  # Requirement: Dynamic block for NSG & Source LoadBalancer
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "AzureLoadBalancer" # LB to backend
      destination_address_prefix = "*"
    }
  }

  tags = local.common_tags
}

# nsg association to subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.priv_1.id
  network_security_group_id = azurerm_network_security_group.sec_gr_1.id
}

#Create Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip
  resource_group_name = azurerm_resource_group.proj_1.name
  location            = azurerm_resource_group.proj_1.location
  allocation_method   = var.resource_alloc_methods.pip
  sku                 = var.resource_skus.pip
  zones               = var.resource_zones.pip
  domain_name_label = "${azurerm_resource_group.proj_1.name}-${random_pet.lb_hostname.id}"

  tags = local.common_tags
}

#Create LB and frontend IP Config
resource "azurerm_lb" "proj_lb" {
  name                = var.lb_name
  resource_group_name = azurerm_resource_group.proj_1.name
  location            = azurerm_resource_group.proj_1.location
  sku                 = var.resource_skus.lb
  

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
  tags = local.common_tags
}

#Create Backend pool for LB
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.lb_backend_pool
  loadbalancer_id = azurerm_lb.proj_lb.id
}

#LB Probe to check the backend is up
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.proj_lb.id
  name            = "http_probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}


#Create Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_pub_ip" {
  name                = var.nat_public_ip
  resource_group_name = azurerm_resource_group.proj_1.name
  location            = azurerm_resource_group.proj_1.location
  allocation_method   = var.resource_alloc_methods.nat_ip
  sku                 = var.resource_skus.nat_ip
  zones               = var.resource_zones.nat_pip

  tags = local.common_tags
}

#Nat Gateway
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.nat_gw
  resource_group_name     = azurerm_resource_group.proj_1.name
  location                = azurerm_resource_group.proj_1.location
  sku_name                = var.resource_skus.pip
  idle_timeout_in_minutes = 10
  zones                   = var.resource_zones.nat_pip

  tags = local.common_tags
}

# Load balancing rule for port 80 traffic
resource "azurerm_lb_rule" "http_rule" {
  name                           = "LBRule"
  loadbalancer_id                = azurerm_lb.proj_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.lb_frontend_ip
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_network_security_rule" "allow_http_inbound" {
  name                        = "Allow-HTTP-Inbound"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.proj_1.name
  network_security_group_name = azurerm_network_security_group.sec_gr_1.name
}


resource "azurerm_network_security_rule" "ssh_nat_rule_nsg" {
  name                        = "Allow-SSH-NAT-Access"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "*"   
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.proj_1.name
  network_security_group_name = azurerm_network_security_group.sec_gr_1.name
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_pub_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.priv_1.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}


## Bastion Host Resources
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.proj_1.name
  virtual_network_name = azurerm_virtual_network.proj_vnet.name
  address_prefixes     = ["10.0.250.0/27"]
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.proj_1.location
  resource_group_name = azurerm_resource_group.proj_1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "proj-bastion"
  location            = azurerm_resource_group.proj_1.location
  resource_group_name = azurerm_resource_group.proj_1.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}