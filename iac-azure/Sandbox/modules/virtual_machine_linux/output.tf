output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "principal_id" {
  value = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

output "tenant_id" {
  value = azurerm_linux_virtual_machine.vm.identity[0].tenant_id
}

