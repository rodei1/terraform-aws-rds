locals {

  ########################################################################
  # Parameter group
  ########################################################################
  create_db_parameter_group       = true
  parameter_group_family          = data.aws_rds_engine_version.engine_info.parameter_group_family
  parameter_group_use_name_prefix = true
  prod_instance_parameters = var.environment == "prod" ? [
    {
      name         = "log_connections"
      value        = 1
      apply_method = "immediate"
    }
  ] : []

  instance_parameters = concat([
    {
      name         = "rds.force_ssl"
      value        = 1 # this might need to be changed back and forth to ensure apply_method is applied. See here: https://github.com/hashicorp/terraform-provider-aws/pull/24737
      apply_method = "immediate"
    }
    ],
    var.instance_parameters,
    local.prod_instance_parameters
  )

  cluster_parameters = concat([
    {
      name         = "rds.force_ssl"
      value        = 1
      apply_method = "immediate"
    }
  ], var.cluster_parameters)

  ########################################################################
  # Subnet group
  ########################################################################
  create_db_subnet_group          = true
  db_subnet_group_use_name_prefix = false
  db_subnet_group_description     = null

  ########################################################################
  # Enhanced Monitoring
  ########################################################################
  create_monitoring_role                        = var.enhanced_monitoring_interval > 0
  monitoring_role_name                          = local.create_monitoring_role ? "${var.identifier}-rds-enhanced-monitoring" : null
  monitoring_role_description                   = local.create_monitoring_role ? "Role for enhanced monitoring of RDS instance ${var.identifier}" : null
  monitoring_role_arn                           = try(module.enhanced_monitoring_iam_role[0].enhanced_monitoring_iam_role_arn, null)
  enhanced_monitoring_role_use_name_prefix      = false
  enhanced_monitoring_role_permissions_boundary = null
  ########################################################################
  # CloudWatch log group config
  ########################################################################
  create_cloudwatch_log_group = length(var.enabled_cloudwatch_logs_exports) > 0

  ########################################################################
  # DB Proxy configuration
  ########################################################################
  # proxy_name          = var.proxy_name == null ? "${var.identifier}" : var.proxy_name
  db_proxy_secret_arn = var.is_proxy_included ? (local.is_serverless ? try(module.db_cluster_serverless[0].cluster_master_user_secret_arn, null) : try(module.db_instance[0].db_instance_master_user_secret_arn, null)) : null
  proxy_auth_config = var.is_proxy_included ? {
    (var.username) = {
      description = "Proxy user for ${var.username}"
      secret_arn  = local.db_proxy_secret_arn # aws_secretsmanager_secret.superuser.arn
      iam_auth    = var.proxy_iam_auth
    }
  } : {}

  ########################################################################
  # Instance configs
  ########################################################################

  iops                      = var.iops == null && var.storage_type == "io1" ? 1000 : var.iops # The minimum value is 1,000 IOPS and the maximum value is 256,000 IOPS. The IOPS to GiB ratio must be between 0.5 and 50
  is_serverless             = var.is_serverless                                               # temporary controlled by variable. TODO: Replace by calculation
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${try(random_id.snapshot_identifier[0].hex, "")}"

  engine = "postgres"

  config = {
    prod = {
      instance_class                        = "db.t3.micro",
      allocated_storage                     = 20,
      max_allocated_storage                 = 50,
      port                                  = 5432, # remove this line to use default port
      instance_is_multi_az                  = true,
      skip_final_snapshot                   = false,
      performance_insights_enabled          = true,
      performance_insights_retention_period = 7,
      delete_automated_backups              = false
    },
    non-prod = {
      instance_class                        = "db.t3.micro",
      allocated_storage                     = 20,
      max_allocated_storage                 = 0,    # TODO: Test this
      port                                  = 5432, # remove this line to use default port
      instance_is_multi_az                  = false,
      skip_final_snapshot                   = true,
      performance_insights_enabled          = false,
      performance_insights_retention_period = null,
      delete_automated_backups              = true
    }
  }

  engine_version                        = data.aws_rds_engine_version.engine_info.version
  is_major_engine_version               = try(length(regexall("\\.[0-9]+$", var.engine_version)) > 0, true) # For example, 15 is a major version, but 15.5 is not
  environment                           = var.environment == "prod" ? var.environment : "non-prod"
  default_config                        = local.config[local.environment]
  instance_class                        = var.instance_class != null ? var.instance_class : local.default_config.instance_class
  allocated_storage                     = var.allocated_storage != null ? var.allocated_storage : local.default_config.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage != null ? var.max_allocated_storage : local.default_config.max_allocated_storage
  password                              = var.manage_master_user_password ? null : var.password
  port                                  = var.port != null ? var.port : local.default_config.port
  db_subnet_group_name                  = module.db_subnet_group[0].db_subnet_group_id
  instance_is_multi_az                  = var.instance_is_multi_az != null ? var.instance_is_multi_az : local.default_config.instance_is_multi_az
  skip_final_snapshot                   = var.skip_final_snapshot != null ? var.skip_final_snapshot : local.default_config.skip_final_snapshot
  performance_insights_enabled          = var.performance_insights_enabled != null ? var.performance_insights_enabled : local.default_config.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period != null ? var.performance_insights_retention_period : local.default_config.performance_insights_retention_period
  delete_automated_backups              = var.delete_automated_backups != null ? var.delete_automated_backups : local.default_config.delete_automated_backups
  backup_retention_period               = null
  backup_window                         = null
  storage_encrypted                     = true

  ########################################################################
  # Tagging
  ########################################################################
  resource_owner_contact_email = var.resource_owner_contact_email != null ? {
    "dfds.owner" = var.resource_owner_contact_email
  } : {}
  automation_initiator_pipeline_tag = var.pipeline_location != null ? { "dfds.automation.initiator.pipeline" : var.pipeline_location } : {}
  all_tags = merge({
    "dfds.env" : var.environment,
    "dfds.cost.centre" : var.cost_centre,
    "dfds.service.availability" : var.service_availability,
    "dfds.automation.tool" : "Terraform",
    "dfds.automation.initiator.location" : "https://github.com/dfds/aws-modules-rds",
  }, var.optional_tags, local.resource_owner_contact_email, local.automation_initiator_pipeline_tag)
  data_backup_retention_tag = var.additional_backup_retention != null ? { "dfds.data.backup.retention" : var.additional_backup_retention } : {}
  data_tags = merge({
    "dfds.data.backup" : var.enable_default_backup,
    "dfds.data.classification" : var.data_classification,
  }, var.optional_data_specific_tags, local.data_backup_retention_tag)

  ########################################################################
  # Kubernetes
  ########################################################################
  kubernetes_namespace = var.is_kubernetes_app_enabled ? trimprefix(data.aws_iam_account_alias.current.account_alias, "dfds-") : null
  oidc_provider        = var.is_kubernetes_app_enabled ? trimprefix(data.aws_ssm_parameter.oidc_provider.value, "https://") : null
}
