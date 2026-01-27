variable "name" {
  type        = string
  description = "name of the public ip"
}

variable "location" {
  type        = string
  description = "The Location in which the public ip will be deployed"
}

variable "rg_name" {
  type        = string
  description = "Resource group of the public ip"
}

variable "allocation_method" {
  type        = string
  description = "allocation_method of the public ip - Static or Dynamic"
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}

/*variable "infra" {
  type = string
  description = "The Infrastructure Deployed (prod,dev)"
}

variable "service" {
  type = string
  description = "The type of service that is deployed"
}

variable "env" {
  type = string
  description = "The name of the environment"
}
*/
