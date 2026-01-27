variable "redis_name" {
  type        = string
  description = "The name of the Redis instance."
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the Redis instance."
}

variable "location" {
  type        = string
  description = "The location of the Redis instance."
}

variable "redis_sku_name" {
  type        = string
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
}

variable "redis_capacity" {
  type        = number
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4, 5."
}

variable "family" {
  type        = string
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

# variable "non_ssl_port_enabled" {
#   type        = bool
#   description = "Enable the non-SSL port (6379) - disabled by default."
# }

variable "minimum_tls_version" {
  type        = string
  description = "The minimum TLS version. Possible values are 1.0, 1.1 and 1.2. Defaults to 1.0."
}

# variable "tags" {
#   type = map(string)
#   description = "tags for this resources"
# }
# Add these variables to your existing variables
variable "subnet_id" {
  type        = string
  description = "Subnet ID for VNet integration (Premium SKU only)"
  default     = null
}

variable "private_static_ip_address" {
  type        = string
  description = "Static private IP address for Redis (required for VNet integration)"
  default     = null
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint for Redis"
  default     = false
}
