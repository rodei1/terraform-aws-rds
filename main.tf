terraform {
  backend "s3" {}
}

resource "random_id" "snapshot_identifier" {
  count = !var.skip_final_snapshot ? 1 : 0

  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

# Create a parameter group by default to contain the options we need
module "db_parameter_group" {
  source          = "./modules/instance_parameter_group"
  count           = local.create_db_parameter_group ? 1 : 0
  name            = var.identifier
  use_name_prefix = var.parameter_group_use_name_prefix
  description     = var.parameter_group_description
  family          = local.parameter_group_family
  parameters      = local.instance_parameters
  tags            = merge(var.tags, var.db_parameter_group_tags)
}

module "db_subnet_group" {
  source          = "./modules/rds_subnet_group"
  count           = local.create_db_subnet_group ? 1 : 0
  name            = coalesce(var.db_subnet_group_name, var.identifier)
  use_name_prefix = var.db_subnet_group_use_name_prefix
  description     = var.db_subnet_group_description
  subnet_ids      = var.subnet_ids
  tags            = merge(var.tags, var.db_subnet_group_tags)
}

module "cw_log_group" {
  source                                = "./modules/cloudwatch_log_groups"
  count                                 = local.create_cloudwatch_log_group ? 1 : 0
  db_identifier                         = var.identifier
  enabled_cw_logs_exports               = var.enabled_cloudwatch_logs_exports
  cw_log_group_retention_in_days        = var.cloudwatch_log_group_retention_in_days
  cw_log_group_kms_key_id               = var.cloudwatch_log_group_kms_key_id
  cw_log_group_skip_destroy_on_deletion = local.cloudwatch_log_group_skip_destroy_on_deletion
}

module "enhanced_monitoring_iam_role" {
  source                               = "./modules/enhanced_monitoring_role"
  count                                = local.create_monitoring_role ? 1 : 0
  monitoring_role_name                 = local.monitoring_role_name
  monitoring_role_use_name_prefix      = var.enhanced_monitoring_role_use_name_prefix
  monitoring_role_description          = local.monitoring_role_description
  monitoring_role_permissions_boundary = var.enhanced_monitoring_role_permissions_boundary
}

module "db_instance" {
  source                                = "./modules/rds_instance"
  count                                 = !var.is_db_cluster && !local.is_serverless ? 1 : 0
  identifier                            = var.identifier
  use_identifier_prefix                 = var.instance_use_identifier_prefix
  engine                                = local.engine
  engine_version                        = local.engine_version
  instance_class                        = var.instance_class
  allocated_storage                     = local.storage_size
  storage_type                          = local.storage_type
  storage_encrypted                     = var.storage_encrypted
  kms_key_id                            = var.kms_key_id
  license_model                         = var.license_model
  db_name                               = var.db_name
  username                              = var.username
  password                              = var.manage_master_user_password ? null : var.password # TODO: Move to locals
  port                                  = var.port
  domain                                = var.domain
  domain_iam_role_name                  = var.domain_iam_role_name
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  custom_iam_instance_profile           = var.custom_iam_instance_profile
  manage_master_user_password           = var.manage_master_user_password
  master_user_secret_kms_key_id         = var.master_user_secret_kms_key_id
  vpc_security_group_ids                = [module.security_group.security_group_id]
  db_subnet_group_name                  = local.db_subnet_group_name
  parameter_group_name                  = module.db_parameter_group[0].db_parameter_group_id
  option_group_name                     = null # Not supported in postgresql
  network_type                          = var.network_type
  availability_zone                     = var.availability_zone
  multi_az                              = var.multi_az
  iops                                  = var.iops
  storage_throughput                    = var.storage_throughput
  publicly_accessible                   = var.publicly_accessible
  ca_cert_identifier                    = var.ca_cert_identifier
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  maintenance_window                    = var.maintenance_window
  blue_green_update                     = var.blue_green_update
  snapshot_identifier                   = var.snapshot_identifier
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier_prefix      = var.final_snapshot_identifier_prefix
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  replicate_source_db                   = var.replicate_source_db
  replica_mode                          = var.replica_mode
  backup_retention_period               = local.backup_retention_period
  backup_window                         = var.backup_window
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_interval                   = var.enhanced_monitoring_interval
  monitoring_role_arn                   = local.monitoring_role_arn
  character_set_name                    = var.character_set_name
  nchar_character_set_name              = var.nchar_character_set_name
  timezone                              = var.timezone
  timeouts                              = var.timeouts
  deletion_protection                   = var.deletion_protection
  delete_automated_backups              = var.delete_automated_backups
  restore_to_point_in_time              = var.restore_to_point_in_time
  s3_import                             = var.s3_import
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  oidc_provider                         = var.oidc_provider
  kubernetes_namespace                  = var.kubernetes_namespace
  tags                                  = merge(var.tags, var.db_instance_tags)
}

module "cluster_parameters" {
  source                                 = "./modules/cluster_parameter_group"
  count                                  = var.is_db_cluster ? 1 : 0
  db_cluster_parameter_group_name        = var.identifier
  db_cluster_parameter_group_family      = local.parameter_group_family
  db_cluster_parameter_group_description = "${var.identifier} DB parameter cluster group"
  db_cluster_parameter_group_parameters  = local.cluster_parameters
}

module "db_multi_az_cluster" {
  source                          = "./modules/rds_aurora"
  count                           = var.is_db_cluster && !local.is_serverless ? 1 : 0
  name                            = var.identifier
  cluster_use_name_prefix         = var.cluster_use_name_prefix
  engine                          = local.engine
  engine_version                  = local.engine_version
  db_subnet_group_name            = local.db_subnet_group_name
  storage_type                    = local.storage_type
  allocated_storage               = local.storage_size
  iops                            = local.iops
  backup_retention_period         = null # Backup is managed by the organization
  db_cluster_instance_class       = var.instance_class
  master_username                 = var.username
  master_password                 = var.password
  manage_master_user_password     = var.manage_master_user_password
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  db_cluster_parameter_group_name = module.cluster_parameters[0].db_cluster_parameter_group_id
  vpc_security_group_ids          = var.vpc_security_group_ids
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = merge(var.tags, var.db_instance_tags)

}


module "db_cluster_serverless" { # TODO: Revisit defaults
  source                      = "./modules/rds_aurora"
  count                       = local.is_serverless ? 1 : 0
  name                        = var.identifier
  engine                      = "aurora-postgresql"
  engine_mode                 = "provisioned"
  engine_version              = local.engine_version
  storage_encrypted           = var.storage_encrypted
  master_username             = var.username
  manage_master_user_password = var.manage_master_user_password
  db_subnet_group_name        = local.db_subnet_group_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  monitoring_interval         = var.enhanced_monitoring_interval
  monitoring_role_arn         = local.monitoring_role_arn
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = var.skip_final_snapshot
  instance_class              = "db.serverless"
  tags                        = var.tags
  serverlessv2_scaling_configuration = { # TODO: Turn values into default in the variable
    min_capacity = 2
    max_capacity = 5
  }
  instances = { # TODO: Revisit this?
    one = {}
    two = {}
  }
}

module "db_proxy" {
  source                                = "./modules/rds_proxy"
  count                                 = var.include_proxy ? 1 : 0
  tags                                  = var.tags
  name                                  = var.identifier
  auth                                  = local.proxy_auth_config
  debug_logging                         = var.proxy_debug_logging
  engine_family                         = var.proxy_engine_family
  idle_client_timeout                   = var.idle_client_timeout
  require_tls                           = var.proxy_require_tls
  role_arn                              = try(module.db_instance[0].iam_role_for_aws_services.arn, null)
  vpc_security_group_ids                = var.rds_proxy_security_group_ids
  vpc_subnet_ids                        = var.subnet_ids
  proxy_tags                            = var.tags
  connection_borrow_timeout             = null
  init_query                            = null
  max_connections_percent               = 100
  max_idle_connections_percent          = 50
  session_pinning_filters               = ["EXCLUDE_VARIABLE_SETS"]
  target_db_instance                    = !var.is_db_cluster
  target_db_cluster                     = var.is_db_cluster
  db_instance_identifier                = var.identifier
  db_cluster_identifier                 = var.identifier
  endpoints                             = {}
  manage_log_group                      = true
  cw_log_group_skip_destroy_on_deletion = local.cloudwatch_log_group_skip_destroy_on_deletion
  log_group_retention_in_days           = var.cloudwatch_log_group_retention_in_days
  log_group_kms_key_id                  = var.cloudwatch_log_group_kms_key_id
  log_group_tags                        = var.tags

}

module "security_group" { # update with another rule for public access
  source                   = "./modules/security_group"
  name                     = var.identifier
  description              = "RDS PostgreSQL security group"
  vpc_id                   = var.vpc_id
  ingress_with_cidr_blocks = var.rds_security_group_rules.ingress_rules
  ingress_with_self        = var.rds_security_group_rules.ingress_with_self
  tags                     = var.tags
}
