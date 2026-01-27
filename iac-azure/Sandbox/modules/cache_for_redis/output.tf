output "id" {
  value       = azurerm_redis_cache.redis_cache.id
  description = "The id of the newly created Redis instance."
}

output "redis_id" {
  value       = azurerm_redis_cache.redis_cache.id
  description = "The id of the newly created Redis instance."
}

output "name" {
  value       = azurerm_redis_cache.redis_cache.name
  description = "The name of the newly created Redis instance"
}
