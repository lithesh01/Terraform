locals {
  # =========================================================================
  # CONFIG LOAD
  # =========================================================================

  # Dynamically determine the YAML file based on the environment name
  # Example: "sandbox" -> "sandbox.yml", "dev" -> "dev.yml"
  # Fallback to sandbox.yml if the specific file does not exist
  env_file = fileexists("${path.module}/${var.environment}.yml") ? "${var.environment}.yml" : "sandbox.yml"

  # Load and decode the YAML configuration file
  config = yamldecode(file("${path.module}/${local.env_file}"))

  # =========================================================================
  # DEPLOYMENT FLAGS
  # =========================================================================
  deploy_resource_group         = local.config.deploy.resource_group
  deploy_VM                     = local.config.deploy.vm
  deploy_log_analytics          = local.config.deploy.log_analytics
  deploy_container_apps         = local.config.deploy.container_apps
  deploy_container_apps_pe      = local.config.deploy.container_apps_pe
  deploy_container_registry     = local.config.deploy.container_registry
  deploy_container_registry_pe  = local.config.deploy.container_registry_pe
  deploy_app_gateway            = local.config.deploy.app_gateway
  deploy_key_vault              = local.config.deploy.key_vault
  deploy_postgres_sql           = local.config.deploy.postgresql
  deploy_recovery_Service_vault = local.config.deploy.recovery_Service_vault
  deploy_vpn_gateway            = local.config.deploy.vpn_gateway
  deploy_storage_account        = local.config.deploy.storage
  deploy_front_door             = local.config.deploy.front_door
  deploy_application_insights   = local.config.deploy.application_insights
  deploy_function_app_plan      = local.config.deploy.function_app_plan
  deploy_function_app           = local.config.deploy.function_app
  deploy_function_app_pe        = local.config.deploy.function_app_pe
  deploy_bastion                = local.config.deploy.bastion
  deploy_redis                  = local.config.deploy.redis
  deploy_redis_pe               = local.config.deploy.redis_pe
  deploy_waf                    = local.config.deploy.waf

  # =========================================================================
  # SCALE SWITCHES (True = Use Custom Lists, False = Use BaseName + Count)
  # =========================================================================
  use_custom_vm_names                   = true
  use_custom_storage_account_names      = false
  use_custom_redis_names                = true
  use_custom_key_vault_names            = true
  use_custom_pg_server_names            = true
  use_custom_acr_names                  = true
  use_custom_environment_names          = true
  use_custom_agw_names                  = true
  use_custom_bastion_names              = true
  use_custom_recovery_vault_names       = true
  use_custom_vpn_gateway_names          = true
  use_custom_function_app_names         = true
  use_custom_function_app_plan_names    = true
  use_custom_front_door_names           = true
  use_custom_application_insights_names = true
  use_custom_log_analytics_names        = true

  # =========================================================================
  # NAMING LOGIC (Calculates Final Lists for main.tf)
  # =========================================================================

  vm_names = local.use_custom_vm_names ? local.config.vm_names : [
    for i in range(local.config.vm_count) : "${local.config.vm_base_name}-${format("%02d", i + 1)}"
  ]

  storage_names = local.use_custom_storage_account_names ? local.config.storage_account_names : [
    for i in range(local.config.storage_account_count) : replace(lower("${local.config.storage_account_base_name}${format("%02d", i + 1)}"), "-", "")
  ]

  redis_names = local.use_custom_redis_names ? local.config.redis_names : [
    for i in range(local.config.redis_count) : "${local.config.redis_base_name}-${format("%02d", i + 1)}"
  ]

  key_vault_names = local.use_custom_key_vault_names ? local.config.key_vault_names : [
    for i in range(local.config.key_vault_count) : "${local.config.key_vault_base_name}-${format("%02d", i + 1)}"
  ]

  pg_server_names = local.use_custom_pg_server_names ? local.config.pg_server_names : [
    for i in range(local.config.pg_server_count) : "${local.config.pg_server_base_name}-${format("%02d", i + 1)}"
  ]

  acr_names = local.use_custom_acr_names ? local.config.acr_names : [
    for i in range(local.config.acr_count) : replace(lower("${local.config.acr_base_name}${format("%02d", i + 1)}"), "-", "")
  ]

  environment_names = local.use_custom_environment_names ? local.config.environment_names : [
    for i in range(local.config.environment_count) : "${local.config.environment_base_name}-${format("%02d", i + 1)}"
  ]

  agw_names = local.use_custom_agw_names ? local.config.agw_names : [
    for i in range(local.config.agw_count) : "${local.config.agw_base_name}-${format("%02d", i + 1)}"
  ]

  bastion_names = local.use_custom_bastion_names ? local.config.bastion_names : [
    for i in range(local.config.bastion_count) : "${local.config.bastion_base_name}-${format("%02d", i + 1)}"
  ]

  recovery_vault_names = local.use_custom_recovery_vault_names ? local.config.recovery_vault_names : [
    for i in range(local.config.recovery_vault_count) : "${local.config.recovery_vault_base_name}-${format("%02d", i + 1)}"
  ]

  vpn_gateway_names = local.use_custom_vpn_gateway_names ? local.config.vpn_gateway_names : [
    for i in range(local.config.vpn_gateway_count) : "${local.config.vpn_gateway_base_name}-${format("%02d", i + 1)}"
  ]

  function_app_names = local.use_custom_function_app_names ? local.config.function_app_names : [
    for i in range(local.config.function_app_count) : "${local.config.function_app_base_name}-${format("%02d", i + 1)}"
  ]

  function_app_plan_names = local.use_custom_function_app_plan_names ? local.config.function_app_plan_names : [
    for i in range(local.config.function_app_plan_count) : "${local.config.function_app_plan_base_name}-${format("%02d", i + 1)}"
  ]

  front_door_names = local.use_custom_front_door_names ? local.config.front_door_names : [
    for i in range(local.config.front_door_count) : "${local.config.front_door_base_name}-${format("%02d", i + 1)}"
  ]

  app_insight_names = local.use_custom_application_insights_names ? local.config.application_insights_names : [
    for i in range(local.config.application_insights_count) : "${local.config.application_insights_base_name}-${format("%02d", i + 1)}"
  ]

  log_analytics_names = local.use_custom_log_analytics_names ? local.config.log_analytics_names : [
    for i in range(local.config.log_analytics_count) : "${local.config.log_analytics_base_name}-${format("%02d", i + 1)}"
  ]
}
