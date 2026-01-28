resource "azurerm_postgresql_flexible_server" "main" {
  name                          = var.name
  resource_group_name           = var.rg_name
  location                      = var.location
  version                       = var.pg_version
  public_network_access_enabled = var.public_network_access_enabled
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id

  authentication {
    active_directory_auth_enabled = length(var.aad_admins) > 0 ? true : false
    password_auth_enabled         = true
  }

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  storage_mb   = var.storage_mb
  storage_tier = var.storage_tier
  sku_name     = var.sku_name
  tags         = var.tags

  lifecycle {
    ignore_changes  = [zone, authentication[0].tenant_id]
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "main" {
  for_each = { for admin in var.aad_admins : admin.principal_name => admin }

  server_name         = azurerm_postgresql_flexible_server.main.name
  resource_group_name = var.rg_name
  tenant_id           = each.value.tenant_id
  object_id           = each.value.object_id
  principal_name      = each.value.principal_name
  principal_type      = each.value.principal_type
}

resource "azurerm_postgresql_flexible_server_configuration" "main" {
  for_each = var.server_parameters

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = each.value
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "main" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  for_each = toset(var.databases)

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
