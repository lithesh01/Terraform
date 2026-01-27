# Central Private DNS Zone for all services in Central India
resource "azurerm_private_dns_zone" "central" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Link to your VNet
resource "azurerm_private_dns_zone_virtual_network_link" "central" {
  name                  = "link-${var.virtual_network_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.central.name
  virtual_network_id    = var.virtual_network_id
  tags                  = var.tags
}

# # DNS A Records (add these to your central DNS module)
# resource "azurerm_private_dns_a_record" "function_app" {
#   name                = "functionapp"
#   zone_name           = azurerm_private_dns_zone.central.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   records             = [var.function_app_private_ip]  # You'll need to pass this IP
# }

# resource "azurerm_private_dns_a_record" "container_app" {
#   name                = "containerapp"
#   zone_name           = azurerm_private_dns_zone.central.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   records             = [var.container_app_private_ip]  # You'll need to pass this IP
# }