resource "azurerm_network_security_rule" "name" {
  name                        = var.nsgrule_name
  priority                    = var.nsgrule_priority
  direction                   = var.nsgrule_direction
  access                      = var.nsgrule_access
  protocol                    = var.nsgrule_protocol
  source_port_range           = var.nsgrule_source_port_range
  destination_port_range      = var.nsgrule_destination_port_range
  source_address_prefix       = var.nsgrule_source_address_prefix
  destination_address_prefix  = var.nsgrule_destination_address_prefix
  resource_group_name         = var.nsg_rule_rg_name
  network_security_group_name = var.nsg_name
}