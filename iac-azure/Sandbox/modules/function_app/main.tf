# Linux Function App
resource "azurerm_linux_function_app" "main" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id            = var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  site_config {
    always_on                              = var.always_on
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key

    application_stack {
      python_version = var.python_version
    }

    vnet_route_all_enabled = var.vnet_route_all_enabled
  }

  app_settings = merge(
    var.app_settings,
    {
      "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = var.storage_account_connection_string
      "WEBSITE_CONTENTSHARE"                     = var.function_app_name
      # Enable private endpoints
      "WEBSITE_VNET_ROUTE_ALL" = var.vnet_route_all_enabled ? "1" : "0"
    }
  )

  public_network_access_enabled = var.public_network_access_enabled



  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [app_settings, site_config, virtual_network_subnet_id]
  }
}

# In ../modules/function-app/main.tf
resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  count = var.vnet_integration_enabled ? 1 : 0

  app_service_id = azurerm_linux_function_app.main.id
  subnet_id      = var.vnet_integration_subnet_id

  # Only create if subnet_id is provided
  lifecycle {
    precondition {
      condition     = var.vnet_integration_subnet_id != null
      error_message = "VNET integration requires a subnet ID. Please provide vnet_integration_subnet_id."
    }

    # Optional: Prevent destruction if function app is in use
    prevent_destroy = true
  }

  depends_on = [azurerm_linux_function_app.main]
}
