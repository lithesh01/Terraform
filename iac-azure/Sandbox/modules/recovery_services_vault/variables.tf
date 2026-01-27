variable "name" {
  type        = string
  description = "Specifies the name of the Recovery Services Vault. Recovery Service Vault name must be 2 - 50 characters long, start with a letter, contain only letters, numbers and hyphens."
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the Recovery Services Vault."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

# variable "tags" {
#   type = map(string)
#   description = "tags for this resources"
# }

variable "sku" {
  type        = string
  description = "Sets the vault's SKU. Possible values include: Standard, RS0."
}

variable "soft_delete_enabled" {
  type        = bool
  description = "Is soft delete enable for this Vault? Defaults to true."
}

variable "public_network_access_enabled" {
  type        = bool
  description = " Is it enabled to access the vault from public networks. Defaults to true."
}

variable "storage_mode_type" {
  type        = string
  description = "The storage type of the Recovery Services Vault. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Defaults to GeoRedundant."
}

# variable "cross_region_restore_enabled" {
#   type        = bool
#   description = " Is cross region restore enabled for this Vault? Only can be true, when storage_mode_type is GeoRedundant. Defaults to false."
# }

