# =========================================================================
# NAMES REGISTRY & CORE RESOURCES
# =========================================================================

# Resource Group
module "resource_group" {
  source   = "../modules/resource_group"
  name     = local.config.rg_name
  location = local.config.location
  tags     = local.config.tags
}

data "azurerm_client_config" "current" {}

# =========================================================================
# NETWORKING
# =========================================================================

# Virtual Network
module "virtual_network" {
  source              = "../modules/virtual_network"
  vnet_name           = local.config.vnet_name
  location            = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  address_space       = local.config.address_space
}

# --- Subnets ---
module "subnet" {
  source              = "../modules/subnet"
  subnet_name         = local.config.vm_common.subnet_name
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.vm_common.subnet_address_prefixes
}

module "container_app_private_endpoints_subnet" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_container_private_endpoints
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_container_private_endpoints
}

module "subnet_bastion" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_bastion
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_bastion_address_prefixes
}

module "subnet_redis_private_endpoint" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_redis_private_endpoint
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_redis_private_endpoint
}

module "subnet_name_agw" {
  source              = "../modules/subnet"
  subnet_name         = "agw-snet"
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_agw
}

module "subnet_private" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_name_private
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_private
}

module "container_app_infra_subnet" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_name_container_app
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_container_app

  delegation_enabled         = true
  delegation_name            = "container-apps-delegation"
  service_delegation_name    = "Microsoft.App/environments"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
}

module "subnet_name_pgsql" {
  source              = "../modules/subnet"
  subnet_name         = local.config.subnet_name_pgsql
  resource_group_name = module.resource_group.rg_name
  vnet_name           = module.virtual_network.vnet_name
  address_prefixes    = local.config.subnet_address_prefixes_pgsql

  delegation_enabled         = true
  delegation_name            = "postgresql-delegation"
  service_delegation_name    = "Microsoft.DBforPostgreSQL/flexibleServers"
  service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
}

resource "azurerm_subnet" "function_app_outbound" {
  name                              = local.config.function_app_outbound_subnet_name
  resource_group_name               = module.resource_group.rg_name
  virtual_network_name              = module.virtual_network.vnet_name
  address_prefixes                  = [local.config.function_app_outbound_subnet_address_prefix]
  private_endpoint_network_policies = local.config.private_endpoint_network_policies

  delegation {
    name = "function-app-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "function_subnet" {
  name                              = local.config.function_subnet_name
  resource_group_name               = module.resource_group.rg_name
  virtual_network_name              = module.virtual_network.vnet_name
  address_prefixes                  = local.config.function_app_subnet_address_prefix
  private_endpoint_network_policies = "Enabled"
}

# --- Network Security Groups ---
module "network_security_group" {
  source   = "../modules/network_security_group"
  name     = local.config.vm_common.nsg_name
  rg_name  = module.resource_group.rg_name
  location = module.resource_group.rg_location
  tags     = local.config.tags
}

module "nsg_association" {
  count                     = local.deploy_VM ? length(local.vm_names) : 0
  source                    = "../modules/nsg_association_to_nic"
  network_interface_id      = local.config.vm_common.has_public_ip ? module.nic_public[count.index].nic_id : module.nic_private[count.index].nic_id
  network_security_group_id = module.network_security_group.nsg_id
}

# --- Public IPs ---
module "public_ip_agw" {
  count             = local.deploy_app_gateway ? length(local.agw_names) : 0
  source            = "../modules/public_ip"
  name              = "${local.agw_names[count.index]}-pip"
  location          = module.resource_group.rg_location
  rg_name           = module.resource_group.rg_name
  allocation_method = "Static"
  tags              = local.config.tags
}

module "vpn_public_ip" {
  count             = local.deploy_vpn_gateway ? length(local.vpn_gateway_names) : 0
  source            = "../modules/public_ip"
  name              = "${local.vpn_gateway_names[count.index]}-pip"
  location          = module.resource_group.rg_location
  rg_name           = module.resource_group.rg_name
  allocation_method = "Static"
  tags              = local.config.tags
}

module "bastion_public_ip" {
  count             = local.deploy_bastion ? length(local.bastion_names) : 0
  source            = "../modules/public_ip"
  name              = "${local.bastion_names[count.index]}-pip"
  location          = module.resource_group.rg_location
  rg_name           = module.resource_group.rg_name
  allocation_method = "Static"
  tags              = local.config.tags
}

module "public_ip_vm" {
  count             = (local.deploy_VM && local.config.vm_common.has_public_ip) ? length(local.vm_names) : 0
  source            = "../modules/public_ip"
  name              = "${local.vm_names[count.index]}-pip"
  location          = module.resource_group.rg_location
  rg_name           = module.resource_group.rg_name
  allocation_method = "Static"
  tags              = local.config.tags
}

# --- Private DNS Zones ---
module "central_dns_zone" {
  source               = "../modules/private_dns_zone"
  resource_group_name  = module.resource_group.rg_name
  dns_zone_name        = local.config.central_dns_zone_name
  virtual_network_id   = module.virtual_network.vnet_id
  virtual_network_name = module.virtual_network.vnet_name
}

module "pg_dns_zone" {
  source               = "../modules/private_dns_zone"
  resource_group_name  = module.resource_group.rg_name
  dns_zone_name        = "privatelink.postgres.database.azure.com"
  virtual_network_id   = module.virtual_network.vnet_id
  virtual_network_name = module.virtual_network.vnet_name
}

module "acr_dns_zone" {
  source               = "../modules/private_dns_zone"
  resource_group_name  = module.resource_group.rg_name
  dns_zone_name        = "privatelink.azurecr.io"
  virtual_network_id   = module.virtual_network.vnet_id
  virtual_network_name = module.virtual_network.vnet_name
}

# =========================================================================
# COMPUTE
# =========================================================================

# --- Network Interfaces ---
module "nic_public" {
  count  = (local.deploy_VM && local.config.vm_common.has_public_ip) ? length(local.vm_names) : 0
  source = "../modules/network_interface_with_public_ip"

  name                 = "${local.vm_names[count.index]}-nic"
  location             = module.resource_group.rg_location
  rg_name              = local.config.vm_common.resource_group
  subnet_id            = module.subnet.id
  public_ip_address_id = module.public_ip_vm[count.index].public_ip_id
  tags                 = local.config.tags
}

module "nic_private" {
  count  = (local.deploy_VM && !local.config.vm_common.has_public_ip) ? length(local.vm_names) : 0
  source = "../modules/network_interface"

  name               = "${local.vm_names[count.index]}-nic"
  location           = module.resource_group.rg_location
  rg_name            = local.config.vm_common.resource_group
  subnet_id          = module.subnet.id
  private_ip_address = "Dynamic"
  tags               = local.config.tags
}

# --- Virtual Machines ---
module "linux_vm" {
  count  = local.deploy_VM ? length(local.vm_names) : 0
  source = "../modules/virtual_machine_linux"

  name                  = local.vm_names[count.index]
  computer_name         = local.vm_names[count.index]
  rg_name               = local.config.vm_common.resource_group
  location              = module.resource_group.rg_location
  vm_size               = local.config.vm_common.size
  admin_username        = local.config.vm_common.admin_username
  admin_password        = local.config.pg_admin_password
  network_interface_ids = local.config.vm_common.has_public_ip ? module.nic_public[count.index].nic_id : module.nic_private[count.index].nic_id

  disable_password_authentication = false
  patch_mode                      = "ImageDefault"
  zone                            = "1"
  secure_boot_enabled             = false
  vtpm_enabled                    = false

  osdisk_name             = "${local.vm_names[count.index]}-osdisk"
  os_caching              = "ReadWrite"
  os_storage_account_type = "Standard_LRS"
  osdisk_size             = local.config.vm_common.os_disk_size

  os_publisher = local.config.vm_common.os_publisher
  os_offer     = local.config.vm_common.os_offer
  os_sku       = local.config.vm_common.os_sku

  enable_entra_id_login        = local.config.vm_common.enable_entra_id_login
  boot_diagnostics_storage_uri = ""

  tags = local.config.tags
}

resource "azurerm_role_assignment" "vm_admin_login" {
  count                = (local.deploy_VM && local.config.vm_common.enable_entra_id_login && lookup(local.config.vm_common, "vm_admin_group_id", "") != "") ? length(local.vm_names) : 0
  scope                = module.linux_vm[count.index].vm_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = local.config.vm_common.vm_admin_group_id
}

# --- Bastion Host ---
module "bastion_host" {
  count                  = local.deploy_bastion ? length(local.bastion_names) : 0
  source                 = "../modules/bastion"
  resource_group_name    = module.resource_group.rg_name
  location               = module.resource_group.rg_location
  bastion_name           = local.bastion_names[count.index]
  subnet_id              = module.subnet_bastion.id
  public_ip_id           = module.bastion_public_ip[count.index].public_ip_id
  sku                    = local.config.bastion_sku
  scale_units            = local.config.bastion_scale_units
  copy_paste_enabled     = local.config.bastion_copy_paste_enabled
  file_copy_enabled      = local.config.bastion_file_copy_enabled
  ip_connect_enabled     = local.config.bastion_ip_connect_enabled
  shareable_link_enabled = local.config.bastion_shareable_link_enabled
  tunneling_enabled      = local.config.bastion_tunneling_enabled
}

# =========================================================================
# STORAGE
# =========================================================================
module "storage_account" {
  count                    = local.deploy_storage_account ? length(local.storage_names) : 0
  source                   = "../modules/storage_account"
  storage_account_name     = local.storage_names[count.index]
  resource_group_name      = module.resource_group.rg_name
  location                 = module.resource_group.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  containers               = try(local.config.storage_containers, [])
  file_shares              = try(local.config.storage_file_shares, [])
}

# =========================================================================
# DATABASES
# =========================================================================

# --- PostgreSQL ---
module "postgresql" {
  count  = local.deploy_postgres_sql ? length(local.pg_server_names) : 0
  source = "../modules/postgresql"

  name                = local.pg_server_names[count.index]
  rg_name             = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  pg_version          = local.config.pg_version
  delegated_subnet_id = module.subnet_name_pgsql.id
  private_dns_zone_id = module.pg_dns_zone.private_dns_zone_id

  administrator_login           = local.config.pg_admin_login
  administrator_password        = local.config.pg_admin_password
  storage_mb                    = local.config.pg_storage_mb
  storage_tier                  = local.config.pg_storage_tier
  sku_name                      = local.config.pg_sku_name
  public_network_access_enabled = local.config.pg_public_network_access_enabled
  server_parameters             = local.config.pg_server_parameters

  firewall_rules = [
    for rule in local.config.pg_firewall_rules : {
      name             = rule.name
      start_ip_address = rule.start_ip
      end_ip_address   = rule.end_ip
    }
  ]

  aad_admins = [
    for name, id in try(local.config.aad_admins, {}) : {
      principal_name = name
      object_id      = id
      tenant_id      = data.azurerm_client_config.current.tenant_id
      principal_type = "User"
    }
  ]

  tags = local.config.tags
}

# --- Redis Cache ---
module "redis" {
  count               = local.deploy_redis ? length(local.redis_names) : 0
  source              = "../modules/cache_for_redis"
  redis_name          = local.redis_names[count.index]
  location            = module.resource_group.rg_location
  rg_name             = module.resource_group.rg_name
  redis_capacity      = local.config.redis_capacity
  family              = local.config.family
  redis_sku_name      = local.config.redis_sku_name
  minimum_tls_version = local.config.minimum_tls_version
}

# =========================================================================
# CONTAINER PLATFORM
# =========================================================================

# --- Container Registry ---
module "acr" {
  count                         = local.deploy_container_registry ? length(local.acr_names) : 0
  source                        = "../modules/acr"
  acrname                       = local.acr_names[count.index]
  rgname                        = module.resource_group.rg_name
  location                      = module.resource_group.rg_location
  acrsku                        = local.config.acr_sku
  public_network_access_enabled = try(local.config.acr_public_network_access_enabled, false)
  retention_policy_days         = try(local.config.acr_retention_policy_days, 7)
  tags                          = local.config.tags
}

# --- Container Apps ---
module "container_app" {
  count  = local.deploy_container_apps ? length(local.environment_names) : 0
  source = "../modules/container_app"

  environment_name = local.environment_names[count.index]

  # Fix Dependency: Use ACR login server from module output
  registry_server            = module.acr[0].acr_login_server
  location                   = module.resource_group.rg_location
  resource_group_name        = module.resource_group.rg_name
  log_analytics_workspace_id = local.deploy_log_analytics ? module.log_analytics[0].id : null
  infrastructure_subnet_id   = module.container_app_infra_subnet.id
  vnet                       = module.virtual_network.vnet_id

  # Workload Profiles
  workload_profiles = try(local.config.workload_profiles, [])

  container_apps = local.config.container_apps

  depends_on = [module.acr_private_endpoint]
}



# =========================================================================
# ROLE ASSIGNMENTS
# =========================================================================

# Allow Container Apps to pull images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  for_each             = local.deploy_container_apps ? module.container_app[0].principal_ids : {}
  scope                = module.acr[0].acr_id
  role_definition_name = "AcrPull"
  principal_id         = each.value
}

# Allow GitHub Self-Hosted Runner (on Azure VM) to push images to ACR
# This enables private CI/CD without using static credentials
resource "azurerm_role_assignment" "acr_push" {
  count                = (local.deploy_VM && local.deploy_container_registry) ? length(local.vm_names) : 0
  scope                = module.acr[0].acr_id
  role_definition_name = "AcrPush"
  principal_id         = module.linux_vm[count.index].principal_id
}

# Private Endpoint for Container App Environment
module "container_app_private_endpoint" {
  count  = local.deploy_container_apps_pe ? length(local.environment_names) : 0
  source = "../modules/private_endpoint"

  private_endpoint_name           = "pe-${local.environment_names[count.index]}"
  location                        = module.resource_group.rg_location
  resource_group_name             = module.resource_group.rg_name
  subnet_id                       = module.container_app_private_endpoints_subnet.id
  private_service_connection_name = "psc-${local.environment_names[count.index]}"
  target_resource_id              = module.container_app[count.index].environment_id
  subresource_names               = ["managedEnvironments"]
  private_dns_zone_id             = module.container_app[count.index].private_dns_zone_id
}

# Private Endpoint for Azure Container Registry
module "acr_private_endpoint" {
  count  = local.deploy_container_registry_pe ? length(local.acr_names) : 0
  source = "../modules/private_endpoint"

  private_endpoint_name           = "pe-${local.acr_names[count.index]}"
  location                        = module.resource_group.rg_location
  resource_group_name             = module.resource_group.rg_name
  subnet_id                       = module.container_app_private_endpoints_subnet.id
  private_service_connection_name = "psc-${local.acr_names[count.index]}"
  target_resource_id              = module.acr[count.index].acr_id
  subresource_names               = ["registry"]
  private_dns_zone_id             = module.acr_dns_zone.private_dns_zone_id
}

# =========================================================================
# APPLICATION GATEWAY & WAF
# =========================================================================

module "waf" {
  count               = local.deploy_app_gateway ? length(local.agw_names) : 0
  source              = "../modules/waf"
  waf_policy_name     = "${local.agw_names[count.index]}-waf"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  policy_settings     = local.config.waf.policy_settings
  custom_rules        = local.config.waf.custom_rules
  managed_rule_sets   = local.config.waf.managed_rule_sets
  tags                = local.config.tags
}

# Conditionally create identity or use existing
locals {
  use_existing_identity = lookup(local.config, "existing_agw_identity_id", "") != ""
  agw_identity_id       = local.use_existing_identity ? local.config.existing_agw_identity_id : (local.deploy_app_gateway ? azurerm_user_assigned_identity.agw_identity[0].id : null)
  agw_principal_id      = local.use_existing_identity ? local.config.existing_agw_identity_principal_id : (local.deploy_app_gateway ? azurerm_user_assigned_identity.agw_identity[0].principal_id : null)
}

resource "azurerm_user_assigned_identity" "agw_identity" {
  count               = (local.deploy_app_gateway && !local.use_existing_identity) ? length(local.agw_names) : 0
  name                = "${local.agw_names[count.index]}-identity"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  tags                = local.config.tags
}

# Role Assignment: AGW Identity -> Local Key Vault
resource "azurerm_role_assignment" "agw_kv_secrets" {
  count                = local.deploy_app_gateway && local.deploy_key_vault ? length(local.agw_names) : 0
  scope                = module.key_vault[0].key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = local.agw_principal_id
}

# External Key Vault Data Source
data "azurerm_key_vault" "external_vault" {
  provider            = azurerm.external
  name                = local.config.cert_key_vault_name
  resource_group_name = local.config.cert_key_vault_rg
}

# Role Assignment for External Key Vault
resource "azurerm_role_assignment" "agw_external_kv_secrets" {
  provider             = azurerm.external
  count                = local.deploy_app_gateway ? length(local.agw_names) : 0
  scope                = data.azurerm_key_vault.external_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = local.agw_principal_id
}

module "application_gateway" {
  count               = local.deploy_app_gateway ? length(local.agw_names) : 0
  source              = "../modules/application_gateway"
  agw_name            = local.agw_names[count.index]
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  subnet_id           = module.subnet_name_agw.id
  public_ip_id        = module.public_ip_agw[count.index].public_ip_id
  waf_policy_id       = local.deploy_waf ? module.waf[count.index].waf_policy_id : null
  managed_identity_id = local.agw_identity_id

  sku = local.config.agw.sku

  autoscale_configuration = local.config.agw.enable_autoscaling ? local.config.agw.autoscale : null

  listeners               = local.config.agw.listeners
  ssl_certificates        = local.config.agw.ssl_certificates
  
  # Dynamically construct backend FQDNs to avoid hardcoded environment suffixes
  backend_pools = [
    for pool in local.config.agw.backend_pools : {
      name         = pool.name
      ip_addresses = pool.ip_addresses
      fqdns        = [
        for fqdn in pool.fqdns : 
          replace(fqdn, local.config.ca_environment_suffix_match, local.deploy_container_apps ? module.container_app[0].environment_default_domain : "example.com")
      ]
    }
  ]

  backend_http_settings = [
    for setting in local.config.agw.backend_http_settings : merge(setting, {
      host_name = setting.host_name != "" ? replace(setting.host_name, local.config.ca_environment_suffix_match, local.deploy_container_apps ? module.container_app[0].environment_default_domain : "example.com") : setting.host_name
    })
  ]

  health_probes = [
    for probe in local.config.agw.health_probes : merge(probe, {
      host = probe.host != "" ? replace(probe.host, local.config.ca_environment_suffix_match, local.deploy_container_apps ? module.container_app[0].environment_default_domain : "example.com") : probe.host
    })
  ]
  routing_rules           = local.config.agw.routing_rules
  redirect_configurations = local.config.agw.redirect_configurations

  tags = local.config.tags
}

# =========================================================================
# SERVERLESS (FUNCTION APPS)
# =========================================================================

module "function_app_plan" {
  count               = local.deploy_function_app_plan ? length(local.function_app_plan_names) : 0
  source              = "../modules/function_app_flex_plan"
  plan_name           = local.function_app_plan_names[count.index]
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  os_type             = local.config.function_app_os_type
  sku_name            = local.config.function_app_sku_name
  tags                = local.config.tags
}

module "function_storage" {
  count                    = local.deploy_function_app ? length(local.function_app_names) : 0
  source                   = "../modules/storage_account"
  storage_account_name     = replace(lower("${local.function_app_names[count.index]}stg"), "-", "")
  resource_group_name      = module.resource_group.rg_name
  location                 = module.resource_group.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  containers               = try(local.config.function_storage_containers, [])
  file_shares              = try(local.config.function_file_shares, [])
}

module "function_app" {
  count  = local.deploy_function_app ? length(local.function_app_names) : 0
  source = "../modules/function_app"

  function_app_name                        = local.function_app_names[count.index]
  resource_group_name                      = module.resource_group.rg_name
  location                                 = module.resource_group.rg_location
  storage_account_name                     = module.function_storage[count.index].storage_account_name
  storage_account_access_key               = module.function_storage[count.index].primary_access_key
  storage_account_connection_string        = module.function_storage[count.index].primary_connection_string
  application_insights_connection_string   = module.application_insights[0].connection_string
  application_insights_instrumentation_key = module.application_insights[0].instrumentation_key
  service_plan_id                          = module.function_app_plan[0].plan_id
  python_version                           = local.config.function_app_python_version
  public_network_access_enabled            = local.config.function_app_public_network_access_enabled

  vnet_integration_enabled   = true
  vnet_integration_subnet_id = azurerm_subnet.function_app_outbound.id
  vnet_route_all_enabled     = true

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }
  tags = local.config.tags
}

# =========================================================================
# CDN
# =========================================================================

module "front_door" {
  count               = local.deploy_front_door ? length(local.front_door_names) : 0
  source              = "../modules/front_door"
  front_door_name     = local.front_door_names[count.index]
  resource_group_name = module.resource_group.rg_name
  sku                 = local.config.front_door.sku
  environment         = var.environment

  endpoints     = local.config.front_door.endpoints
  origin_groups = local.config.front_door.origin_groups
  origins       = local.config.front_door.origins
  routes        = local.config.front_door.routes
}

# =========================================================================
# OBSERVABILITY & SECURITY
# =========================================================================

module "log_analytics" {
  count               = local.deploy_log_analytics ? length(local.log_analytics_names) : 0
  source              = "../modules/log_analytics"
  name                = local.log_analytics_names[count.index]
  location            = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  retention_days      = 30
}

module "application_insights" {
  count                     = local.deploy_application_insights ? length(local.app_insight_names) : 0
  source                    = "../modules/application_insights"
  application_insights_name = local.app_insight_names[count.index]
  location                  = module.resource_group.rg_location
  resource_group_name       = module.resource_group.rg_name
  application_type          = local.config.application_insights_type
  workspace_id              = local.deploy_log_analytics ? module.log_analytics[0].id : null
}

module "key_vault" {
  count               = local.deploy_key_vault ? length(local.key_vault_names) : 0
  source              = "../modules/key_vault"
  key_vault_name      = local.key_vault_names[count.index]
  location            = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  owner_users         = []
}

module "recovery_services_vault" {
  count                         = local.deploy_recovery_Service_vault ? length(local.recovery_vault_names) : 0
  source                        = "../modules/recovery_services_vault"
  name                          = local.recovery_vault_names[count.index]
  location                      = module.resource_group.rg_location
  rg_name                       = local.config.recovery_vault_resource_group
  sku                           = local.config.recovery_vault_sku
  soft_delete_enabled           = local.config.recovery_vault_soft_delete_enabled
  storage_mode_type             = local.config.recovery_vault_storage_mode_type
  public_network_access_enabled = local.config.recovery_vault_public_network_access_enabled
}
