variable "name" {
  type        = string
  description = "The name which should be used for this PostgreSQL Flexible Server."
}

variable "rg_name" {
  type        = string
  description = "The name of the Resource Group where the PostgreSQL Flexible Server should exist."
}

variable "location" {
  type        = string
  description = "The Azure Region where the PostgreSQL Flexible Server should exist."
}

variable "pg_version" {
  type        = string
  description = "The version of the PostgreSQL Flexible Server to use."
}

variable "storage_mb" {
  type        = number
  description = "The max storage allowed for the PostgreSQL Flexible Server."
}

variable "administrator_login" {
  type        = string
  description = "The Administrator login for the PostgreSQL Flexible Server."
}

variable "administrator_password" {
  type        = string
  description = "The Password associated with the administrator_login."
}

variable "sku_name" {
  type        = string
  description = "The SKU Name for the PostgreSQL Flexible Server."
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the Private DNS Zone."
  default     = null
}

variable "delegated_subnet_id" {
  type        = string
  description = "The ID of the virtual network subnet."
  default     = null
}

variable "storage_tier" {
  type        = string
  description = "The name of storage performance tier."
}

variable "aad_admins" {
  description = "List of Azure AD administrators"
  type = list(object({
    tenant_id      = string
    object_id      = string
    principal_name = string
    principal_type = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled."
  default     = false
}

variable "server_parameters" {
  type        = map(string)
  description = "Map of PostgreSQL server configuration parameters."
  default     = {}
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = []
}
