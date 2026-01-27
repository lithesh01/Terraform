variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "agw_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for Application Gateway"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP"
  type        = string
}

variable "waf_policy_id" {
  description = "ID of the WAF policy"
  type        = string
  default     = null
}

variable "sku" {
  description = "SKU configuration for Application Gateway"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}

variable "autoscale_configuration" {
  description = "Autoscaling configuration. If provided, capacity in SKU will be ignored."
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "managed_identity_id" {
  description = "ID of the managed identity for Application Gateway"
  type        = string
  default     = null
}

variable "listeners" {
  description = "HTTP listeners configuration"
  type = list(object({
    name                 = string
    frontend_port_name   = string
    port                 = number
    protocol             = string
    host_name            = string
    ssl_certificate_name = string
  }))
  default = []
}

variable "backend_pools" {
  description = "Backend address pools configuration"
  type = list(object({
    name         = string
    fqdns        = list(string)
    ip_addresses = list(string)
  }))
  default = []
}

variable "backend_http_settings" {
  description = "Backend HTTP settings configuration"
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    request_timeout                     = number
    probe_name                          = string
    connection_draining_enabled         = bool
    connection_draining_timeout         = number
    pick_host_name_from_backend_address = bool
    host_name                           = string
  }))
  default = []
}

variable "health_probes" {
  description = "Health probes configuration"
  type = list(object({
    name                                      = string
    protocol                                  = string
    host                                      = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    match_status_codes                        = list(string)
    pick_host_name_from_backend_http_settings = bool
  }))
  default = []
}

variable "routing_rules" {
  description = "Request routing rules configuration"
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string, null)
    backend_http_settings_name  = optional(string, null)
    redirect_configuration_name = optional(string, null)
    priority                    = number
  }))
  default = []
}

variable "redirect_configurations" {
  description = "Redirect configurations for Application Gateway"
  type = list(object({
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string, null)
    target_url           = optional(string, null)
    include_path         = optional(bool, true)
    include_query_string = optional(bool, true)
  }))
  default = []
}

variable "ssl_certificates" {
  description = "SSL certificates from Key Vault"
  type = list(object({
    name                = string
    key_vault_secret_id = string
  }))
  default = []
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
