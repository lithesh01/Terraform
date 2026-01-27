output "plan_id" {
  description = "App service plan ID"
  value       = azurerm_service_plan.main.id
}

output "plan_name" {
  description = "App service plan name"
  value       = azurerm_service_plan.main.name
}