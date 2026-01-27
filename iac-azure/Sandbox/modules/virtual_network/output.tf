output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}