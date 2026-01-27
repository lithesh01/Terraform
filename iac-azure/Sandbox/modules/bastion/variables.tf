variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "bastion_name" {
  description = "Name of the bastion host"
  type        = string
}

variable "subnet_id" {
  description = "ID of the bastion subnet"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP for bastion"
  type        = string
}

variable "sku" {
  description = "SKU of the bastion host"
  type        = string
  default     = "Standard"
}

variable "scale_units" {
  description = "Scale units for bastion host"
  type        = number
  default     = 2
}

variable "copy_paste_enabled" {
  description = "Enable copy paste feature"
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "Enable file copy feature"
  type        = bool
  default     = true
}

variable "ip_connect_enabled" {
  description = "Enable IP connect feature"
  type        = bool
  default     = true
}

variable "shareable_link_enabled" {
  description = "Enable shareable link feature"
  type        = bool
  default     = true
}

variable "tunneling_enabled" {
  description = "Enable tunneling feature"
  type        = bool
  default     = true
}