variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "plan_name" {
  description = "Name of the app service plan"
  type        = string
}

variable "os_type" {
  description = "OS type for function app"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU name for flex consumption plan"
  type        = string
  default     = "EP1"
}
variable "tags" {
  type        = map(string)
  description = "Tags for the Service Plan"
  default     = {}
}