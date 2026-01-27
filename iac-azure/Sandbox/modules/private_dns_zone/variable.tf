variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the central DNS zone"
  type        = string
  default     = "privatelink.centralindia.everstage.com"
}

variable "virtual_network_id" {
  description = "ID of the virtual network to link"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "function_app_private_ip" {
  description = "Private IP address of the Function App"
  type        = string
  default     = null # You can set a default or make it required
}

variable "container_app_private_ip" {
  description = "Private IP address of the Container App"
  type        = string
  default     = null # You can set a default or make it required
}