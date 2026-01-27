# VM Group Outputs
output "vm_admin_group_id" {
  description = "Object ID of the VM Administrators group"
  value       = var.enable_vm_access ? azuread_group.vm_admins[0].object_id : null
}

output "vm_user_group_id" {
  description = "Object ID of the VM Users group"
  value       = var.enable_vm_access ? azuread_group.vm_users[0].object_id : null
}

# PostgreSQL Group Outputs
output "postgresql_admin_group_id" {
  description = "Object ID of the PostgreSQL Administrators group"
  value       = var.enable_postgresql_access ? azuread_group.postgresql_admins[0].object_id : null
}

output "postgresql_reader_group_id" {
  description = "Object ID of the PostgreSQL Readers group"
  value       = var.enable_postgresql_access ? azuread_group.postgresql_readers[0].object_id : null
}