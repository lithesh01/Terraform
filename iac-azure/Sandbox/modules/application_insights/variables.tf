variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "application_insights_name" {
  description = "Name of the application insights"
  type        = string
}

variable "application_type" {
  description = "Application type for insights"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
  default     = null
}