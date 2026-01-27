resource "azurerm_application_gateway" "main" {
  name                = var.agw_name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.autoscale_configuration == null ? var.sku.capacity : null
  }

  gateway_ip_configuration {
    name      = "${var.agw_name}-ip-config"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.listeners
    content {
      name = frontend_port.value.frontend_port_name
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                 = "${var.agw_name}-frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      host_name                           = backend_http_settings.value.pick_host_name_from_backend_address ? null : backend_http_settings.value.host_name

      dynamic "connection_draining" {
        for_each = backend_http_settings.value.connection_draining_enabled ? [1] : []
        content {
          enabled           = true
          drain_timeout_sec = backend_http_settings.value.connection_draining_timeout
        }
      }
    }
  }

  dynamic "http_listener" {
    for_each = var.listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "${var.agw_name}-frontend-ip"
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = http_listener.value.host_name
      ssl_certificate_name           = http_listener.value.ssl_certificate_name != "" ? http_listener.value.ssl_certificate_name : null
    }
  }

  dynamic "probe" {
    for_each = var.health_probes
    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      host                                      = probe.value.pick_host_name_from_backend_http_settings ? null : probe.value.host
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      match {
        status_code = probe.value.match_status_codes
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.redirect_configuration_name == null ? request_routing_rule.value.backend_address_pool_name : null
      backend_http_settings_name  = request_routing_rule.value.redirect_configuration_name == null ? request_routing_rule.value.backend_http_settings_name : null
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      priority                    = request_routing_rule.value.priority
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.value.name
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  firewall_policy_id = var.waf_policy_id

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
