output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

# output "certificate_id" {
#   description = "ID of the certificate"
#   value       = azurerm_key_vault_certificate.appgw.id
# }

# output "certificate_secret_id" {
#   description = "Secret ID of the certificate for Application Gateway"
#   value       = azurerm_key_vault_certificate.appgw.secret_id
# }

# output "certificate_name" {
#   description = "Name of the certificate"
#   value       = azurerm_key_vault_certificate.appgw.name
# }