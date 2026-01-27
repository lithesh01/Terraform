variable "name" {
  type        = string
  description = "Name of the Network Interface"
}

variable "location" {
  type        = string
  description = "location of the Network Interface"
}

variable "rg_name" {
  type        = string
  description = "resource group name of the Network Interface"
}

variable "subnet_id" {
  type        = string
  description = "subnet_id name of the Network Interface"
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}

variable "public_ip_address_id" {
  type        = string
  description = "public_ip_address_id of the Network Interface"
}