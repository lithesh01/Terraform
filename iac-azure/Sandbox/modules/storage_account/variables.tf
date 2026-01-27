variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "static_website_index_document" {
  description = "The name of the index document for the static website"
  type        = string
  default     = "index.html"
}

variable "static_website_error_document" {
  description = "The name of the error document for the static website"
  type        = string
  default     = "404.html"
}

variable "containers" {
  description = "List of containers to create in the storage account"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "file_shares" {
  description = "List of file shares to create in the storage account"
  type = list(object({
    name  = string
    quota = number
  }))
  default = []
}
