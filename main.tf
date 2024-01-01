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

resource "null_resource" "validate_instance_type_proxy" { # TODO: need to enforce dependency in proxy module
  count = var.is_cluster && var.is_proxy_included ? 1 : 0

  provisioner "local-exec" {
    command = "Running a check"
  }

  lifecycle {
    precondition {
      condition     = var.is_cluster && var.is_proxy_included
      error_message = "Cannot create a proxy for a DB cluster"
    }
  }
}

# Create a parameter group by default to contain the options we need
module "db_parameter_group" {
  source          = "./modules/instance_parameter_group"
  count           = local.create_db_parameter_group ? 1 : 0
  name            = var.identifier
  use_name_prefix = local.parameter_group_use_name_prefix
  family          = local.parameter_group_family
  parameters      = local.instance_parameters
  tags            = local.all_tags
}

module "db_subnet_group" {
  source          = "./modules/rds_subnet_group"
  count           = local.create_db_subnet_group ? 1 : 0
  name            = var.identifier
  use_name_prefix = local.db_subnet_group_use_name_prefix
  description     = local.db_subnet_group_description
  subnet_ids      = var.subnet_ids
  tags            = local.all_tags
}

module "cw_log_group" {
  source                                = "./modules/cloudwatch_log_groups"
  count                                 = local.create_cloudwatch_log_group ? 1 : 0
  db_identifier                         = var.identifier
  enabled_cw_logs_exports               = var.enabled_cloudwatch_logs_exports
  cw_log_group_retention_in_days        = var.cloudwatch_log_group_retention_in_days
  cw_log_group_kms_key_id               = var.cloudwatch_log_group_kms_key_id
  cw_log_group_skip_destroy_on_deletion = var.cloudwatch_log_group_skip_destroy_on_deletion
  tags                                  = local.all_tags
}

module "enhanced_monitoring_iam_role" {
  source                               = "./modules/enhanced_monitoring_role"
  count                                = local.create_monitoring_role ? 1 : 0
  monitoring_role_name                 = local.monitoring_role_name
  monitoring_role_use_name_prefix      = local.enhanced_monitoring_role_use_name_prefix
  monitoring_role_description          = local.monitoring_role_description
  monitoring_role_permissions_boundary = local.enhanced_monitoring_role_permissions_boundary
  tags                                 = local.all_tags
}

module "db_instance" {
  source                                = "./modules/rds_instance"
  count                                 = var.create_db_instance ? 1 : 0
  identifier                            = var.identifier
  use_identifier_prefix                 = false
  engine                                = local.engine
  engine_version                        = local.engine_version
  instance_class                        = local.instance_class
  allocated_storage                     = local.allocated_storage
  max_allocated_storage                 = local.max_allocated_storage
  storage_type                          = var.storage_type
  storage_encrypted                     = local.storage_encrypted
  db_name                               = var.db_name
  username                              = var.username
  password                              = local.password
  port                                  = local.port
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  manage_master_user_password           = var.manage_master_user_password
  vpc_security_group_ids                = [module.security_group.security_group_id]
  db_subnet_group_name                  = local.db_subnet_group_name
  parameter_group_name                  = module.db_parameter_group[0].db_parameter_group_id
  network_type                          = var.network_type
  availability_zone                     = var.availability_zone
  multi_az                              = local.instance_is_multi_az
  iops                                  = var.iops
  storage_throughput                    = var.storage_throughput
  publicly_accessible                   = var.publicly_accessible
  ca_cert_identifier                    = var.ca_cert_identifier
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  apply_immediately                     = var.apply_immediately
  maintenance_window                    = var.maintenance_window
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  skip_final_snapshot                   = local.skip_final_snapshot
  final_snapshot_identifier_prefix      = var.final_snapshot_identifier_prefix
  snapshot_identifier                   = var.source_snapshot_identifier
  performance_insights_enabled          = local.performance_insights_enabled
  performance_insights_retention_period = local.performance_insights_retention_period
  backup_retention_period               = local.backup_retention_period
  backup_window                         = local.backup_window
  monitoring_interval                   = var.enhanced_monitoring_interval
  monitoring_role_arn                   = local.monitoring_role_arn
  timeouts                              = var.instance_terraform_timeouts
  deletion_protection                   = var.deletion_protection
  delete_automated_backups              = local.delete_automated_backups
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  oidc_provider                         = local.oidc_provider
  kubernetes_namespace                  = local.kubernetes_namespace
  tags                                  = local.all_tags
  rds_tags                              = local.data_tags
}

module "cluster_parameters" {
  source                                 = "./modules/cluster_parameter_group"
  count                                  = var.is_cluster ? 1 : 0
  db_cluster_parameter_group_name        = var.identifier
  db_cluster_parameter_group_family      = local.parameter_group_family
  db_cluster_parameter_group_description = "${var.identifier} DB parameter cluster group"
  db_cluster_parameter_group_parameters  = local.cluster_parameters
}

module "db_multi_az_cluster" {
  source                          = "./modules/rds_aurora"
  count                           = var.is_cluster && !local.is_serverless ? 1 : 0
  name                            = var.identifier
  cluster_use_name_prefix         = var.cluster_use_name_prefix
  engine                          = local.engine
  engine_version                  = local.engine_version
  db_subnet_group_name            = local.db_subnet_group_name
  storage_type                    = var.storage_type
  allocated_storage               = local.allocated_storage
  iops                            = local.iops
  backup_retention_period         = null # Backup is managed by the organization
  db_cluster_instance_class       = var.instance_class
  master_username                 = var.username
  master_password                 = local.password
  manage_master_user_password     = var.manage_master_user_password
  apply_immediately               = var.apply_immediately
  storage_encrypted               = local.storage_encrypted
  db_cluster_parameter_group_name = module.cluster_parameters[0].db_cluster_parameter_group_id
  vpc_security_group_ids          = [module.security_group.security_group_id]
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = local.all_tags # might also need to add rds_tags

}


module "db_cluster_serverless" { # TODO: Revisit defaults and rename to aurora serverless
  source                      = "./modules/rds_aurora"
  count                       = local.is_serverless ? 1 : 0
  name                        = var.identifier
  engine                      = "aurora-postgresql"
  engine_mode                 = "provisioned"
  engine_version              = local.engine_version
  storage_encrypted           = local.storage_encrypted
  master_username             = var.username
  manage_master_user_password = var.manage_master_user_password
  db_subnet_group_name        = local.db_subnet_group_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  monitoring_interval         = var.enhanced_monitoring_interval
  monitoring_role_arn         = local.monitoring_role_arn
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = var.skip_final_snapshot
  instance_class              = "db.serverless"
  tags                        = local.all_tags # might also need to add rds_tags
  serverlessv2_scaling_configuration = {       # TODO: Turn values into default in the variable
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
  count                                 = var.is_proxy_included ? 1 : 0
  tags                                  = local.all_tags
  name                                  = var.identifier
  auth                                  = local.proxy_auth_config
  debug_logging                         = var.proxy_debug_logging_is_enabled
  engine_family                         = var.proxy_engine_family
  idle_client_timeout                   = var.proxy_idle_client_timeout
  require_tls                           = var.proxy_require_tls
  role_arn                              = try(module.db_instance[0].iam_role_for_aws_services.arn, module.db_cluster_serverless[0].iam_role_for_aws_services.arn, null) # TODO: Fix iam_role_for_aws_services for db_cluster_serverless by adding required IAM resources
  vpc_security_group_ids                = [module.security_group_proxy[0].security_group_id]
  vpc_subnet_ids                        = var.subnet_ids
  proxy_tags                            = local.all_tags
  connection_borrow_timeout             = null
  init_query                            = null
  max_connections_percent               = 100
  max_idle_connections_percent          = 50
  session_pinning_filters               = ["EXCLUDE_VARIABLE_SETS"]
  target_db_instance                    = !var.is_cluster
  target_db_cluster                     = var.is_cluster
  db_instance_identifier                = var.identifier
  db_cluster_identifier                 = var.identifier
  endpoints                             = {}
  manage_log_group                      = true
  cw_log_group_skip_destroy_on_deletion = var.cloudwatch_log_group_skip_destroy_on_deletion
  log_group_retention_in_days           = var.cloudwatch_log_group_retention_in_days
  log_group_kms_key_id                  = var.cloudwatch_log_group_kms_key_id
  log_group_tags                        = local.all_tags

}

module "security_group" { # TODO: update with another rule for public access
  source                   = "./modules/security_group"
  name                     = var.identifier
  description              = "RDS PostgreSQL security group"
  vpc_id                   = var.vpc_id
  ingress_with_cidr_blocks = var.rds_security_group_rules.ingress_rules
  ingress_with_self        = var.rds_security_group_rules.ingress_with_self
  egress_with_cidr_blocks  = var.rds_security_group_rules.egress_rules
  tags                     = local.all_tags
}

module "security_group_proxy" {
  source                   = "./modules/security_group"
  count                    = var.is_proxy_included ? 1 : 0
  name                     = "${var.identifier}-proxy"
  description              = "RDS PostgreSQL security group for proxy"
  vpc_id                   = var.vpc_id
  ingress_with_cidr_blocks = var.proxy_security_group_rules.ingress_rules
  ingress_with_self = concat([{
    from_port = local.port
    to_port   = local.port
    protocol  = "tcp"
    description = "PostgreSQL access from within Security Gruop" }],
  var.proxy_security_group_rules.ingress_with_self)
  egress_with_source_security_group_id = [{
    source_security_group_id = module.security_group.security_group_id
    from_port                = local.port
    to_port                  = local.port
    protocol                 = "-1"
    description              = "Allow outbound traffic to PostgreSQL instance"
    }
  ]
  tags = local.all_tags
}
