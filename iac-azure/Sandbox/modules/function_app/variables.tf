variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "function_app_name" {
  description = "Name of the function app"
  type        = string
}

variable "service_plan_id" {
  description = "ID of the app service plan"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key for storage account"
  type        = string
  sensitive   = true
}

variable "storage_account_connection_string" {
  description = "Connection string for storage account"
  type        = string
  sensitive   = true
}

variable "application_insights_connection_string" {
  description = "Application insights connection string"
  type        = string
  sensitive   = true
}

variable "application_insights_instrumentation_key" {
  description = "Application insights instrumentation key"
  type        = string
  sensitive   = true
}

variable "always_on" {
  description = "Always on setting"
  type        = bool
  default     = true
}

variable "python_version" {
  description = "Python version"
  type        = string
  default     = "3.11"
}

variable "app_settings" {
  description = "Additional app settings"
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Function App"
  type        = bool
  default     = true # Default to true for backward compatibility
}

variable "vnet_route_all_enabled" {
  description = "Enable outbound VNET integration - routes all outbound traffic through VNet"
  type        = bool
  default     = false
}

variable "vnet_integration_subnet_id" {
  description = "Subnet ID for VNET integration (outbound traffic)"
  type        = string
  default     = null
}

variable "vnet_integration_enabled" {
  description = "Enable VNET integration"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Function App"
  default     = {}
}