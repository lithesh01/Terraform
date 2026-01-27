output "bastion_id" {
  description = "Bastion host ID"
  value       = azurerm_bastion_host.main.id
}

output "bastion_name" {
  description = "Bastion host name"
  value       = azurerm_bastion_host.main.name
}

output "bastion_dns_name" {
  description = "Bastion host DNS name"
  value       = azurerm_bastion_host.main.dns_name
}