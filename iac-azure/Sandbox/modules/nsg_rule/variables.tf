variable "nsg_rule_rg_name" {
  type        = string
  description = "Name of the resource group"
}

variable "nsg_name" {
  type        = string
  description = "Name of the network security group"
}

variable "nsgrule_name" {
  type        = string
  description = "Name of the network security rule"
}

variable "nsgrule_priority" {
  type        = number
  description = "Priority for the rule"
}

variable "nsgrule_direction" {
  type        = string
  description = "Inbound or Outbound"
}

variable "nsgrule_access" {
  type        = string
  description = "Allow"
}

variable "nsgrule_protocol" {
  type        = string
  description = "TCP"
}

variable "nsgrule_source_port_range" {
  type        = string
  description = "*"
}

variable "nsgrule_destination_port_range" {
  type        = string
  description = "Mention the port number thet needed to be open"
}

variable "nsgrule_source_address_prefix" {
  type        = string
  description = "*"
}

variable "nsgrule_destination_address_prefix" {
  type        = string
  description = "*"
}