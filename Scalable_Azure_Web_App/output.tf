output "load_balancer_public_ip" {
  description = "The Public IP address of the Load Balancer"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "nat_gateway_public_ip" {
  description = "The Public IP address used by NAT Gateway for outbound traffic"
  value       = azurerm_public_ip.nat_pub_ip.ip_address
}