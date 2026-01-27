resource "azurerm_web_application_firewall_policy" "waf" {
  name                = var.waf_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action

      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions
        content {
          dynamic "match_variables" {
            for_each = match_conditions.value.match_variables
            content {
              variable_name = match_variables.value.variable_name
              selector      = match_variables.value.selector
            }
          }
          operator           = match_conditions.value.operator
          negation_condition = match_conditions.value.negation_condition
          match_values       = match_conditions.value.match_values
          transforms         = match_conditions.value.transforms
        }
      }

      rate_limit_duration  = custom_rules.value.rule_type == "RateLimitRule" ? custom_rules.value.rate_limit_duration : null
      rate_limit_threshold = custom_rules.value.rule_type == "RateLimitRule" ? custom_rules.value.rate_limit_threshold : null
      group_rate_limit_by  = custom_rules.value.rule_type == "RateLimitRule" ? custom_rules.value.group_rate_limit_by : null

    }
  }

  policy_settings {
    enabled                     = var.policy_settings.enabled
    mode                        = var.policy_settings.mode
    request_body_check          = var.policy_settings.request_body_check
    max_request_body_size_in_kb = var.policy_settings.max_request_body_size_in_kb
    file_upload_limit_in_mb     = var.policy_settings.file_upload_limit_in_mb
  }

  managed_rules {
    dynamic "managed_rule_set" {
      for_each = var.managed_rule_sets
      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version

        dynamic "rule_group_override" {
          for_each = managed_rule_set.value.rule_group_override
          content {
            rule_group_name = rule_group_override.value.rule_group_name
            dynamic "rule" {
              for_each = rule_group_override.value.rule
              content {
                id      = rule.value.id
                enabled = rule.value.enabled
                action  = rule.value.action
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
