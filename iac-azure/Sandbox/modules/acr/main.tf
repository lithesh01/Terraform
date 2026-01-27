resource "azurerm_container_registry" "acr" {
  name                          = var.acrname
  resource_group_name           = var.rgname
  location                      = var.location
  sku                           = var.acrsku
  admin_enabled                 = true
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.acrsku == "Premium" ? var.zone_redundancy_enabled : false
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    prevent_destroy = true
  }
}
