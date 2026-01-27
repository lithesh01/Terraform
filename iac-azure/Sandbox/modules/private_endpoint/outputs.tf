output "private_endpoint_id" {
  description = "Private endpoint ID"
  value       = azurerm_private_endpoint.main.id
}

output "private_endpoint_name" {
  description = "Private endpoint name"
  value       = azurerm_private_endpoint.main.name
}

output "private_ip_address" {
  description = "Private IP address of the endpoint"
  value       = azurerm_private_endpoint.main.private_service_connection[0].private_ip_address
}