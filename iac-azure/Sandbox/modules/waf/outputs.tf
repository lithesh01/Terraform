output "waf_policy_id" {
  description = "The ID of the WAF Policy"
  value       = azurerm_web_application_firewall_policy.waf.id
}

output "waf_policy_name" {
  description = "The name of the WAF Policy"
  value       = azurerm_web_application_firewall_policy.waf.name
}
