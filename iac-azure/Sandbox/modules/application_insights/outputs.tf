output "application_insights_id" {
  description = "Application insights ID"
  value       = azurerm_application_insights.main.id
}

output "application_insights_name" {
  description = "Application insights name"
  value       = azurerm_application_insights.main.name
}

output "instrumentation_key" {
  description = "Application insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "Application insights connection string"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}