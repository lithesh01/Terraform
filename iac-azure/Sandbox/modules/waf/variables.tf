variable "waf_policy_name" {
  description = "The name of the WAF policy"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "policy_settings" {
  description = "Policy settings for WAF"
  type = object({
    enabled                     = optional(bool, true)
    mode                        = optional(string, "Prevention")
    request_body_check          = optional(bool, true)
    max_request_body_size_in_kb = optional(number, 128)
    file_upload_limit_in_mb     = optional(number, 100)
  })
  default = {}
}

variable "custom_rules" {
  description = "List of custom rules"
  type = list(object({
    name      = string
    priority  = number
    rule_type = string
    action    = string
    match_conditions = list(object({
      match_variables = list(object({
        variable_name = string
        selector      = optional(string, null)
      }))
      operator           = string
      negation_condition = optional(bool, false)
      match_values       = list(string)
      transforms         = optional(list(string), [])
    }))
    rate_limit_duration  = optional(string, "OneMin")
    rate_limit_threshold = optional(number, null)
    group_rate_limit_by  = optional(string, "ClientAddr")
  }))
  default = []
}

variable "managed_rule_sets" {
  description = "List of managed rule sets"
  type = list(object({
    type    = string
    version = string
    rule_group_override = optional(list(object({
      rule_group_name = string
      rule = optional(list(object({
        id      = string
        enabled = optional(bool, false)
        action  = optional(string, "Block")
      })), [])
    })), [])
  }))
  default = [
    {
      type    = "OWASP"
      version = "3.2"
    }
  ]
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
