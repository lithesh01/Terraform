variable "name" {
  type        = string
  description = "The name of the Redis instance."
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the Redis instance."
}

variable "redis_cache_name" {
  type        = string
  description = "The name of the Redis Cache."
}

variable "start_ip" {
  type        = string
  description = "The lowest IP address included in the range"
}

variable "end_ip" {
  type        = string
  description = "The highest IP address included in the range."
}

variable "tags" {
  type        = map(string)
  description = "tags for this resources"
}
