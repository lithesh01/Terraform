output "private_dns_zone_id" {
  description = "Central private DNS zone ID"
  value       = azurerm_private_dns_zone.central.id
}

output "private_dns_zone_name" {
  description = "Central private DNS zone name"
  value       = azurerm_private_dns_zone.central.name
}