resource "azurerm_redis_cache" "redis_cache" {
  name                          = var.redis_name
  location                      = var.location
  resource_group_name           = var.rg_name
  capacity                      = var.redis_capacity
  family                        = var.family
  sku_name                      = var.redis_sku_name
  public_network_access_enabled = false
  minimum_tls_version           = var.minimum_tls_version

  # Private endpoint works for Standard/Premium.

  lifecycle {
    prevent_destroy = true
  }
}


