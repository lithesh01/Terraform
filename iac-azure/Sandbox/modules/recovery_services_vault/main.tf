resource "azurerm_recovery_services_vault" "recovery_services_vault" {
  name                          = var.name #Recovery Service Vault name must be 2 - 50 characters long, start with a letter, contain only letters, numbers and hyphens.
  location                      = var.location
  resource_group_name           = var.rg_name
  sku                           = var.sku                           #Possible values include: Standard, RS0.
  soft_delete_enabled           = var.soft_delete_enabled           #Defaults to true.
  public_network_access_enabled = var.public_network_access_enabled #Defaults to true.
  storage_mode_type             = var.storage_mode_type             # Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Defaults to GeoRedundant.
  # cross_region_restore_enabled  = var.cross_region_restore_enabled  #Only can be true, when storage_mode_type is GeoRedundant. Defaults to false.
  # tags                          = var.tags

  # lifecycle {
  #   prevent_destroy = true
  # }
}
