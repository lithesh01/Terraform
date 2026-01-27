resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes

  # Add these new properties
  private_endpoint_network_policies = var.private_endpoint_network_policies
  service_endpoints                 = var.service_endpoints

  # optional service delegations (only add if you need delegated subnet for AKS/ContainerApps/etc)
  dynamic "delegation" {
    for_each = var.delegation_enabled ? [1] : []
    content {
      name = var.delegation_name

      service_delegation {
        name    = var.service_delegation_name
        actions = var.service_delegation_actions
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

