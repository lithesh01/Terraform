output "id" {
  value       = azurerm_redis_firewall_rule.redis_firewall_rule.id
  description = "The id of the newly created redis_firewall_rule"
}

output "name" {
  value       = azurerm_redis_firewall_rule.redis_firewall_rule.name
  description = "The name of the newly created redis_firewall_rule"
}
