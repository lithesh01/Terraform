resource "azurerm_key_vault" "main" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = false
  sku_name                        = "standard"

  # Enable RBAC authorization
  enable_rbac_authorization = true

  lifecycle {
    prevent_destroy = true
  }
}

# Get current client (Terraform service principal)
data "azurerm_client_config" "current" {}

# Get user principal IDs from Azure AD
# data "azuread_user" "users" {
#   for_each = toset(var.owner_users)

#   user_principal_name = each.key
# }

# RBAC Role Assignment for Terraform Service Principal
# resource "azurerm_role_assignment" "terraform_key_vault_admin" {
#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# # RBAC Role Assignment for Key Vault Owners
# resource "azurerm_role_assignment" "key_vault_owner" {
#   for_each = data.azuread_user.users

#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Owner"
#   principal_id         = each.value.object_id
# }

# RBAC Role Assignment for Application Gateway Managed Identity
# resource "azurerm_role_assignment" "appgw_key_vault_secrets_user" {
#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = var.application_gateway_principal_id
# }

# RBAC Role Assignment for Application Gateway Managed Identity - Certificate User
# resource "azurerm_role_assignment" "appgw_key_vault_certificates_user" {
#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Certificate User"
#   principal_id         = var.application_gateway_principal_id
# }

# Create certificate directly in Key Vault
# resource "azurerm_key_vault_certificate" "appgw" {
#   name         = var.certificate_name
#   key_vault_id = azurerm_key_vault.main.id

#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }

#     key_properties {
#       exportable = true
#       key_size   = 2048
#       key_type   = "RSA"
#       reuse_key  = true
#     }

#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }

#     x509_certificate_properties {
#       extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
#       key_usage = [
#         "cRLSign",
#         "dataEncipherment",
#         "digitalSignature",
#         "keyAgreement",
#         "keyCertSign",
#         "keyEncipherment",
#       ]
#       subject_alternative_names {
#         dns_names = var.certificate_san_dns_names
#       }
#       subject            = "CN=${var.certificate_common_name}"
#       validity_in_months = 12
#     }
#   }

#   depends_on = [
#     azurerm_key_vault.main,
#     azurerm_role_assignment.terraform_key_vault_admin,
#     azurerm_role_assignment.key_vault_owner,
#     azurerm_role_assignment.appgw_key_vault_secrets_user,
#     azurerm_role_assignment.appgw_key_vault_certificates_user
#   ]
# }
