resource "azurerm_container_app_environment" "con-env-app" {
  name                       = var.environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # VNet Integration
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = true

  # Workload Profiles
  dynamic "workload_profile" {
    for_each = var.workload_profiles
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }

  # tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_container_app" "con-app" {
  for_each = var.container_apps

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.con-env-app.id
  resource_group_name          = var.resource_group_name
  revision_mode                = each.value.revision_mode

  identity {
    type = each.value.identity_type
  }

  dynamic "registry" {
    for_each = var.registry_server != "" ? [1] : []
    content {
      server   = var.registry_server
      identity = "system"
    }
  }

  template {
    min_replicas = each.value.min_replicas
    max_replicas = each.value.max_replicas

    dynamic "container" {
      for_each = each.value.containers
      content {
        name    = container.value.name
        image   = container.value.image
        cpu     = container.value.cpu
        memory  = container.value.memory
        command = container.value.command

        dynamic "env" {
          for_each = container.value.env
          content {
            name  = env.value.name
            value = env.value.value
          }
        }

        dynamic "volume_mounts" {
          for_each = container.value.volume_mounts
          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.path
          }
        }
      }
    }

    dynamic "volume" {
      for_each = each.value.volumes
      content {
        name         = volume.value.name
        storage_type = volume.value.storage_type
      }
    }
  }

  workload_profile_name = each.value.workload_profile_name

  dynamic "ingress" {
    for_each = each.value.ingress_enabled ? [1] : []
    content {
      external_enabled = each.value.ingress_external_enabled
      target_port      = each.value.target_port
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Private DNS Zone for internal Container Apps
resource "azurerm_private_dns_zone" "container_apps" {
  name                = "private.azurecontainerapps.io"
  resource_group_name = var.resource_group_name
}

# Link Private DNS Zone to your VNet
resource "azurerm_private_dns_zone_virtual_network_link" "container_apps" {
  name                  = "container-apps-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.container_apps.name
  virtual_network_id    = var.vnet
}
