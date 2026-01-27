variable "name" {
  type        = string
  description = "The Infrastructure Deployed (prod,dev)"
}

variable "location" {
  type        = string
  description = "The Location in which the resource will be deployed"
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
