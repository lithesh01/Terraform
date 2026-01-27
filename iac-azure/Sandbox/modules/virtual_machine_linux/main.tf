resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.name
  computer_name                   = var.computer_name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  patch_mode                      = var.patch_mode
  zone                            = var.zone
  secure_boot_enabled             = var.secure_boot_enabled
  vtpm_enabled                    = var.vtpm_enabled
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }

  # lifecycle {
  #   ignore_changes = [identity]
  # }

  boot_diagnostics {
    storage_account_uri = ""
  }
  network_interface_ids = [
    var.network_interface_ids,
  ]

  os_disk {
    name                 = var.osdisk_name
    caching              = var.os_caching
    storage_account_type = var.os_storage_account_type
    disk_size_gb         = var.osdisk_size
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = "latest"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# resource "time_sleep" "wait_for_identity" {
#   count = var.enable_entra_id_login ? 1 : 0

#   create_duration = "60s"

#   depends_on = [azurerm_linux_virtual_machine.vm]
# }

resource "azurerm_virtual_machine_extension" "aad_login" {
  count = var.enable_entra_id_login ? 1 : 0

  name                 = "AADSSHLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"

  tags = var.tags

  # Explicit dependency on VM identity being fully provisioned
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}