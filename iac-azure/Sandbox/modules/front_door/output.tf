output "front_door_id" {
  description = "The ID of the Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.main.id
}

output "front_door_name" {
  description = "The name of the Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.main.name
}

output "endpoints" {
  description = "Map of Front Door endpoints"
  value = {
    for k, v in azurerm_cdn_frontdoor_endpoint.main : k => {
      id        = v.id
      host_name = v.host_name
    }
  }
}

output "origin_group_ids" {
  description = "Map of origin group IDs"
  value       = { for k, v in azurerm_cdn_frontdoor_origin_group.main : k => v.id }
}

output "origin_ids" {
  description = "Map of origin IDs"
  value       = { for k, v in azurerm_cdn_frontdoor_origin.main : k => v.id }
}

output "route_ids" {
  description = "Map of route IDs"
  value       = { for k, v in azurerm_cdn_frontdoor_route.main : k => v.id }
}
