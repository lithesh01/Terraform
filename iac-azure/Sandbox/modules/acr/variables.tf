variable "acrname" {
  type        = string
  description = "the name of the container registry"
}

variable "rgname" {
  type        = string
  description = "the name of the container registry"
}

variable "location" {
  type        = string
  description = "the name of the container registry"
}

variable "acrsku" {
  type        = string
  description = "the name of the container registry"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed"
  default     = false
}

variable "retention_policy_days" {
  type        = number
  description = "Number of days to retain untagged manifests"
  default     = 7
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "Whether zone redundancy is enabled"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}
