# VM Admin Group
resource "azuread_group" "vm_admins" {
  count = var.enable_vm_access ? 1 : 0

  display_name     = var.vm_admin_group_name
  security_enabled = true
  description      = "Administrators with full access to virtual machines"
  owners           = var.group_owners
  members          = var.vm_admin_users

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

# VM User Group
resource "azuread_group" "vm_users" {
  count = var.enable_vm_access ? 1 : 0

  display_name     = var.vm_user_group_name
  security_enabled = true
  description      = "Users with standard access to virtual machines"
  owners           = var.group_owners
  members          = var.vm_user_users

  # Wait for vm_admins to complete first
  depends_on = [azuread_group.vm_admins]

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

# PostgreSQL Admin Group
resource "azuread_group" "postgresql_admins" {
  count = var.enable_postgresql_access ? 1 : 0

  display_name     = var.postgresql_admin_group_name
  security_enabled = true
  description      = "Administrators with full access to PostgreSQL"
  owners           = var.group_owners
  members          = var.postgresql_admin_users

  # Wait for vm_users to complete first
  depends_on = [azuread_group.vm_users]

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

# PostgreSQL Reader Group
resource "azuread_group" "postgresql_readers" {
  count = var.enable_postgresql_access ? 1 : 0

  display_name     = var.postgresql_reader_group_name
  security_enabled = true
  description      = "Users with read access to PostgreSQL"
  owners           = var.group_owners
  members          = var.postgresql_reader_users

  # Wait for postgresql_admins to complete first
  depends_on = [azuread_group.postgresql_admins]

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

# VM Role Assignments
resource "azurerm_role_assignment" "vm_admin_role" {
  count = var.enable_vm_access ? 1 : 0

  scope                = var.virtual_machine_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = azuread_group.vm_admins[0].object_id
}

resource "azurerm_role_assignment" "vm_user_role" {
  count = var.enable_vm_access ? 1 : 0

  scope                = var.virtual_machine_id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_group.vm_users[0].object_id
}

# PostgreSQL Role Assignments
resource "azurerm_role_assignment" "postgresql_admin_role" {
  count = var.enable_postgresql_access ? 1 : 0

  scope                = var.postgresql_server_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.postgresql_admins[0].object_id
}

resource "azurerm_role_assignment" "postgresql_reader_role" {
  count = var.enable_postgresql_access ? 1 : 0

  scope                = var.postgresql_server_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.postgresql_readers[0].object_id
}