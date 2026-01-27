variable "rg_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "name" {
  description = "The name of the virtual mchine."
  type        = string
}

variable "computer_name" {
  description = "The computer_name of the virtual mchine."
  type        = string
}

variable "location" {
  description = "The location of the virtual mchine."
  type        = string
}


variable "vm_size" {
  description = "VM Size to be created"
  type        = string
}

variable "admin_username" {
  description = "VM Username"
  type        = string
}

variable "admin_password" {
  description = "VM Password"
  type        = string
}

variable "disable_password_authentication" {
  type        = bool
  description = "Should Password Authentication be disabled on this Virtual Machine? Defaults to true"
}

variable "network_interface_ids" {
  description = "network interface of the virtual machine"
  type        = string
}

# variable "availability_set_id" {
#   description = "availability_set of the virtual machine"
#   type = string
# }

# variable "enable_automatic_updates" {
#   description = "automatic updates for the virtual machine. Value accepted - true, false"
#   type = string
# }

variable "patch_mode" {
  description = "available options for patch mode of vm is - Manual, AutomaticByOS, AutomaticByPlatform. if automatic update is enabled default is set to AutomaticByOS."
  type        = string
}

# variable "license_type" {
#   description = "license_type of the virtual machine, accepted value - None, Windows_Client, Windows_Server."
#   type = string
# }

variable "zone" {
  description = "Zone in which VM will be deployed - Supported value in String 1,2 & 3"
  type        = string
  default     = ""
}

variable "secure_boot_enabled" {
  description = "secure_boot_enabled for the virtual machine, accepted value - true, false"
  type        = bool
}

variable "vtpm_enabled" {
  description = "vtpm_enabled for the virtual machine, accepted value - true, false"
  type        = bool
}

variable "os_publisher" {
  description = "Publisher"
  type        = string
  default     = ""
}

variable "os_offer" {
  description = "Offer"
  type        = string
  default     = ""
}

variable "os_sku" {
  description = "SKU"
  type        = string
  default     = ""
}

/*variable "total" {
  type = number
  description = "total number reguired"
}*/

variable "osdisk_size" {
  type        = number
  description = "OS Disk Size in GB"
}

variable "os_storage_account_type" {
  type        = string
  description = "storage_account_type for os disk of the vm"
}

variable "osdisk_name" {
  type        = string
  description = "name of the OS Disk"
}

variable "os_caching" {
  type        = string
  description = "caching for OS Disk"
}

variable "enable_entra_id_login" {
  description = "Enable Azure AD (Entra ID) passwordless login"
  type        = bool
  default     = true
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage account URI for boot diagnostics"
  type        = string
  default     = ""
}
variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}

