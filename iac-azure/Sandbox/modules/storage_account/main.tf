resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account_static_website" "main" {
  storage_account_id = azurerm_storage_account.main.id

  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_document
}

resource "azurerm_storage_container" "main" {
  for_each              = { for c in var.containers : c.name => c }
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = each.value.access_type
}

resource "azurerm_storage_share" "main" {
  for_each           = { for s in var.file_shares : s.name => s }
  name               = each.value.name
  storage_account_id = azurerm_storage_account.main.id
  quota              = each.value.quota
}
