variable "front_door_name" {
  description = "The name of the Front Door profile"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku" {
  description = "The SKU of the Front Door"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "endpoints" {
  description = "Map of Front Door endpoints"
  type = map(object({
    name = string
  }))
}

variable "origin_groups" {
  description = "Map of origin groups"
  type = map(object({
    health_probe = object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    })
    load_balancing = object({
      additional_latency_in_milliseconds = number
      sample_size                        = number
      successful_samples_required        = number
    })
    session_affinity_enabled             = optional(bool, false)
    restore_to_healed_or_new_endpoint_ms = optional(number, 10)
  }))
}

variable "origins" {
  description = "Map of origins"
  type = map(object({
    origin_group_key       = string
    host_name              = string
    http_port              = optional(number, 80)
    https_port             = optional(number, 443)
    origin_host_header     = string
    priority               = optional(number, 1)
    weight                 = optional(number, 1000)
    certificate_name_check = optional(bool, true)
    enabled                = optional(bool, true)
  }))
}

variable "routes" {
  description = "Map of routes"
  type = map(object({
    endpoint_key           = string
    origin_group_key       = string
    origin_keys            = list(string)
    patterns_to_match      = list(string)
    supported_protocols    = optional(list(string), ["Http", "Https"])
    forwarding_protocol    = optional(string, "HttpsOnly")
    https_redirect_enabled = optional(bool, true)
    link_to_default_domain = optional(bool, true)
  }))
}
