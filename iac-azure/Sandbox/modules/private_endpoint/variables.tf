variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "private_endpoint_name" {
  description = "Name of the private endpoint"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "target_resource_id" {
  description = "ID of the target resource (Function App)"
  type        = string
}

variable "private_service_connection_name" {
  description = "Name of the private service connection"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names for the private endpoint"
  type        = list(string)
  default     = ["sites"]
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID (optional)"
  type        = string
  default     = null
}