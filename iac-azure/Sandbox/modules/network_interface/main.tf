resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address == "Dynamic" ? "Dynamic" : "Static"
    private_ip_address            = var.private_ip_address == "Dynamic" ? null : var.private_ip_address
  }
}