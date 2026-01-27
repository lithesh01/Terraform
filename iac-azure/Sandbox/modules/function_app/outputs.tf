output "function_app_id" {
  description = "Function app ID"
  value       = azurerm_linux_function_app.main.id
}

output "function_app_name" {
  description = "Function app name"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_default_hostname" {
  description = "Function app default hostname"
  value       = azurerm_linux_function_app.main.default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Function app outbound IP addresses"
  value       = azurerm_linux_function_app.main.outbound_ip_addresses
}

output "function_app_vnet_integration" {
  description = "VNET integration details"
  value = {
    enabled           = var.vnet_integration_enabled
    subnet_id         = var.vnet_integration_subnet_id
    route_all_enabled = var.vnet_route_all_enabled
  }
}

output "vnet_integration_id" {
  description = "ID of the VNET integration"
  value       = try(azurerm_app_service_virtual_network_swift_connection.main[0].id, null)
}
