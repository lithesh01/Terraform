variable "environment" {
  description = "The target environment (e.g., sandbox, dev, test). This name must match your {env}.yml config file."
  type        = string
  default     = "sandbox"
}

variable "external_subscription_id" {
  description = "Subscription ID where the external Key Vault is located"
  type        = string
}
