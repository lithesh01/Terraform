# VM Configuration
variable "virtual_machine_id" {
  type        = string
  description = "The ID of the virtual machine to assign roles to"
  default     = null
}

variable "enable_vm_access" {
  type        = bool
  description = "Whether to enable VM access"
  default     = false
}

# PostgreSQL Configuration
variable "postgresql_server_id" {
  type        = string
  description = "The ID of the PostgreSQL server to assign roles to"
  default     = null
}

variable "enable_postgresql_access" {
  type        = bool
  description = "Whether to enable PostgreSQL access"
  default     = false
}

# Group Configuration
variable "vm_admin_group_name" {
  type        = string
  description = "Display name for the VM Administrators group"
  default     = "VM-Admins"
}

variable "vm_user_group_name" {
  type        = string
  description = "Display name for the VM Users group"
  default     = "VM-Users"
}

variable "postgresql_admin_group_name" {
  type        = string
  description = "Display name for the PostgreSQL Administrators group"
  default     = "PostgreSQL-Admins"
}

variable "postgresql_reader_group_name" {
  type        = string
  description = "Display name for the PostgreSQL Readers group"
  default     = "PostgreSQL-Readers"
}

# User Management
variable "vm_admin_users" {
  type        = list(string)
  description = "Object IDs of users to add to VM Admins group"
  default     = []
}

variable "vm_user_users" {
  type        = list(string)
  description = "Object IDs of users to add to VM Users group"
  default     = []
}

variable "postgresql_admin_users" {
  type        = list(string)
  description = "Object IDs of users to add to PostgreSQL Admins group"
  default     = []
}

variable "postgresql_reader_users" {
  type        = list(string)
  description = "Object IDs of users to add to PostgreSQL Readers group"
  default     = []
}

variable "group_owners" {
  type        = list(string)
  description = "Object IDs of users who will own the groups"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}