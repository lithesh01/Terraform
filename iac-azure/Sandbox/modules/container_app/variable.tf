variable "environment_name" {
  type        = string
  description = "Name of the Container App Environment"
}

variable "location" {
  type = string
}

variable "registry_server" {
  type        = string
  description = "The container registry server URL"
}

variable "vnet" {
  type = string
}
variable "resource_group_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "infrastructure_subnet_id" {
  description = "The ID of the subnet for Container App Environment VNet integration"
  type        = string
}

variable "workload_profiles" {
  description = "List of workload profiles for the Container App Environment"
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
}

variable "container_apps" {
  description = "Map of container apps to deploy"
  type = map(object({
    name                     = string
    ingress_enabled          = optional(bool, false)
    ingress_external_enabled = optional(bool, false)
    target_port              = optional(number, 80)
    revision_mode            = optional(string, "Single")
    identity_type            = optional(string, "SystemAssigned")
    workload_profile_name    = optional(string, "Consumption")
    min_replicas             = optional(number, 1)
    max_replicas             = optional(number, 10)

    containers = list(object({
      name    = string
      image   = string
      cpu     = number
      memory  = string
      command = optional(list(string))
      env = optional(list(object({
        name  = string
        value = string
      })), [])
      volume_mounts = optional(list(object({
        name = string
        path = string
      })), [])
    }))

    volumes = optional(list(object({
      name         = string
      storage_type = string
    })), [])
  }))
  default = {}
}
