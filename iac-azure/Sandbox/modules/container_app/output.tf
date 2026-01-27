output "principal_ids" {
  value = { for k, v in azurerm_container_app.con-app : k => v.identity[0].principal_id }
}

output "environment_id" {
  value = azurerm_container_app_environment.con-env-app.id
}

output "environment_default_domain" {
  value = azurerm_container_app_environment.con-env-app.default_domain
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.container_apps.id
}
