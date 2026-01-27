variable "name" {
  type        = string
  description = "Name of the network security group"
}

variable "location" {
  type        = string
  description = "Location of the network security group"
}

variable "rg_name" {
  type        = string
  description = "Resource Group of the network security group"
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}
