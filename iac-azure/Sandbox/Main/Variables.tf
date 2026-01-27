variable "environment" {
  description = "The target environment (e.g., sandbox, dev, test). This name must match your {env}.yml config file."
  type        = string
  default     = "sandbox"
}
