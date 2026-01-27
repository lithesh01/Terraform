variable "name" {
  description = "Base name for VPN gateway resources"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vpn_gateway_sku" {
  description = "SKU for VPN Gateway"
  type        = string
  default     = "VpnGw1"
}
variable "gateway_subnet_id" {
  description = "ID of the gateway subnet"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the public IP for VPN gateway"
  type        = string
}

variable "public_ip_address_id" {
  description = "Existing Public IP Address ID"
  type        = string
}

# variable "tags" {
#   description = "Tags to apply to resources"
#   type        = map(string)
# }