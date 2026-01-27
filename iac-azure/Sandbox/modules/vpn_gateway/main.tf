# resource "azurerm_public_ip" "vpn_gateway_pip" {
#   name                = var.public_ip_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   # tags                = var.tags
# }

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "vgw-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpn_gateway_sku
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  # tags = var.tags
}

