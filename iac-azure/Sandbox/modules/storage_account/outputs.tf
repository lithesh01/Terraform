output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.main.name
}

output "primary_connection_string" {
  description = "Storage account primary connection string"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "primary_access_key" {
  description = "Storage account primary access key"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "primary_web_host" {
  value = azurerm_storage_account.main.primary_web_host
}

output "primary_web_endpoint" {
  description = "The primary web endpoint for static website hosting"
  value       = azurerm_storage_account.main.primary_web_endpoint
}