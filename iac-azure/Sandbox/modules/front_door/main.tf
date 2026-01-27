# Create Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = var.front_door_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku
  tags = {
    Environment = var.environment
  }
}

# Create Front Door Endpoints
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  for_each                 = var.endpoints
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

# Create Origin Groups
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  for_each                 = var.origin_groups
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  health_probe {
    interval_in_seconds = each.value.health_probe.interval_in_seconds
    path                = each.value.health_probe.path
    protocol            = each.value.health_probe.protocol
    request_type        = each.value.health_probe.request_type
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }

  session_affinity_enabled = each.value.session_affinity_enabled
}

# Create Origins
resource "azurerm_cdn_frontdoor_origin" "main" {
  for_each                      = var.origins
  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main[each.value.origin_group_key].id
  enabled                       = each.value.enabled
  host_name                     = each.value.host_name
  http_port                     = each.value.http_port
  https_port                    = each.value.https_port
  origin_host_header            = each.value.origin_host_header
  priority                      = each.value.priority
  weight                        = each.value.weight

  certificate_name_check_enabled = each.value.certificate_name_check
}

# Create Routes
resource "azurerm_cdn_frontdoor_route" "main" {
  for_each                      = var.routes
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main[each.value.endpoint_key].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main[each.value.origin_group_key].id
  cdn_frontdoor_origin_ids      = [for origin_key in each.value.origin_keys : azurerm_cdn_frontdoor_origin.main[origin_key].id]

  supported_protocols    = each.value.supported_protocols
  patterns_to_match      = each.value.patterns_to_match
  forwarding_protocol    = each.value.forwarding_protocol
  link_to_default_domain = each.value.link_to_default_domain
  https_redirect_enabled = each.value.https_redirect_enabled
}
