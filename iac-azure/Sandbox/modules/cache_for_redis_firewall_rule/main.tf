resource "azurerm_redis_firewall_rule" "redis_firewall_rule" {
  name                = var.name
  redis_cache_name    = var.redis_cache_name
  resource_group_name = var.rg_name
  start_ip            = var.start_ip
  end_ip              = var.end_ip
}