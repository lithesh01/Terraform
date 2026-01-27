variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name that contains the vnet"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network name"
}

variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the subnet (list)"
  default     = ["10.0.1.0/24"]
}

variable "delegation_enabled" {
  type    = bool
  default = false
}

variable "delegation_name" {
  type    = string
  default = ""
}

variable "service_delegation_name" {
  type    = string
  default = ""
}

variable "service_delegation_actions" {
  type    = list(string)
  default = []
}

variable "private_endpoint_network_policies" {
  description = "Enable or disable network policies for private endpoints on this subnet"
  type        = string
  default     = "Enabled"
}

variable "service_endpoints" {
  description = "Service endpoints to associate with the subnet"
  type        = list(string)
  default     = []
}



