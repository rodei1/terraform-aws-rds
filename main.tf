# generate terraform resources for rds
locals {

    # deploy_options_group = var.engine != "postgres"

    # is_multi_az_cluster = var.is_multi_az_cluster ? create_multi_az_db_cluster : create_db_instance
    instance_class = var.instance_class
    final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${try(random_id.snapshot_identifier[0].hex, "")}"


    storage_size = var.allocated_storage == null && var.storage_type == "gp2" ? 5 : var.allocated_storage # Console suggests 20 GB as minumum storage

    monitoring_role_name = var.create_monitoring_role && var.monitoring_role_name == null ? "${var.identifier}-rds-enhanced-monitoring" : var.monitoring_role_name
    monitoring_role_description = var.create_monitoring_role && var.monitoring_role_description == null ? "Role for enhanced monitoring of RDS instance ${var.identifier}" : var.monitoring_role_description

    create_cloudwatch_log_group = length(var.enabled_cloudwatch_logs_exports) > 0

    cloudwatch_log_group_skip_destroy_on_deletion = true

    parameter_group_name = var.create_db_parameter_group && var.parameter_group_name == null ? "${var.identifier}-rds-parameters" : var.parameter_group_name

    family = var.create_db_parameter_group && var.family == null ? "postgres${var.engine}" : var.family
}
resource "random_id" "snapshot_identifier" {
  count = !var.skip_final_snapshot ? 1 : 0

  keepers = {
    id = var.identifier
  }

  byte_length = 4
}

# Focus on exposing required variables
# and use default values for optional ones
# Provide options for providing abstraction on top of the resourc

# resource "aws_rds_cluster" "default" {
#   cluster_identifier      = "aurora-cluster-demo"
#   engine                  = "aurora-mysql"
#   engine_version          = "5.7.mysql_aurora.2.03.2"
#   availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   database_name           = "mydb"
#   master_username         = "foo"
#   master_password         = "bar"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
#   # tags = var.tags_group1
# }

module "db" {
    count = var.is_db_cluster ? 0 : 1

    source = "../opensource_tf_modules//terraform-aws-rds"

    identifier = var.identifier

    create_db_parameter_group = var.create_db_parameter_group # Disabled for now

    instance_class = local.instance_class

    skip_final_snapshot = var.skip_final_snapshot
    create_db_instance = var.create_db_instance

    instance_use_identifier_prefix = var.instance_use_identifier_prefix
    custom_iam_instance_profile = var.custom_iam_instance_profile
    allocated_storage = local.storage_size # var.allocated_storage
    storage_type = var.storage_type
    storage_throughput = var.storage_throughput
    storage_encrypted = var.storage_encrypted
    kms_key_id = var.kms_key_id
    replicate_source_db = var.replicate_source_db
    license_model = var.license_model
    replica_mode = var.replica_mode
    iam_database_authentication_enabled = var.iam_database_authentication_enabled
    domain = var.domain
    domain_iam_role_name = var.domain_iam_role_name
    engine = var.engine #
    engine_version = var.engine_version
    snapshot_identifier = var.snapshot_identifier
    copy_tags_to_snapshot = var.copy_tags_to_snapshot
    final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
    db_name = var.db_name
    username = var.username
    password = var.password
    manage_master_user_password = var.manage_master_user_password
    master_user_secret_kms_key_id = var.master_user_secret_kms_key_id
    port = var.port
    vpc_security_group_ids = var.vpc_security_group_ids
    availability_zone = var.availability_zone
    multi_az = var.multi_az
    iops = var.iops
    publicly_accessible = var.publicly_accessible
    monitoring_interval = var.monitoring_interval
    monitoring_role_arn = var.monitoring_role_arn
    monitoring_role_name = local.monitoring_role_name
    monitoring_role_use_name_prefix = var.monitoring_role_use_name_prefix
    monitoring_role_description = local.monitoring_role_description
    create_monitoring_role = var.create_monitoring_role
    monitoring_role_permissions_boundary = var.monitoring_role_permissions_boundary
    allow_major_version_upgrade = var.allow_major_version_upgrade
    auto_minor_version_upgrade = var.auto_minor_version_upgrade
    apply_immediately = var.apply_immediately
    maintenance_window = var.maintenance_window
    blue_green_update = var.blue_green_update
    backup_retention_period = var.backup_retention_period
    backup_window = var.backup_window
    restore_to_point_in_time = var.restore_to_point_in_time
    s3_import = var.s3_import
    tags = var.tags
    db_instance_tags = var.db_instance_tags
    db_option_group_tags = var.db_option_group_tags
    db_parameter_group_tags = var.db_parameter_group_tags
    db_subnet_group_tags = var.db_subnet_group_tags
    create_db_subnet_group = var.create_db_subnet_group # we don't want to create db_subnet_group
    db_subnet_group_name = var.db_subnet_group_name
    db_subnet_group_use_name_prefix = var.db_subnet_group_use_name_prefix # we don't want to create db_subnet_group
    db_subnet_group_description = var.db_subnet_group_description # we don't want to create db_subnet_group
    subnet_ids = var.subnet_ids # we don't want to create db_subnet_group
    parameter_group_name = local.parameter_group_name
    parameter_group_use_name_prefix = var.parameter_group_use_name_prefix
    parameter_group_description = var.parameter_group_description
    family = local.family
    parameters = var.parameters
    option_group_name = var.option_group_name
    option_group_use_name_prefix = var.option_group_use_name_prefix
    option_group_description = var.option_group_description
    major_engine_version = var.option_group_description
    options = var.options
    timezone = var.timezone
    character_set_name = var.character_set_name
    nchar_character_set_name = var.nchar_character_set_name
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
    timeouts = var.timeouts
    option_group_timeouts = var.option_group_timeouts
    deletion_protection = var.deletion_protection
    performance_insights_enabled = var.performance_insights_enabled
    performance_insights_retention_period = var.performance_insights_retention_period
    performance_insights_kms_key_id = var.performance_insights_kms_key_id
    max_allocated_storage = var.max_allocated_storage
    ca_cert_identifier = var.ca_cert_identifier
    delete_automated_backups = var.delete_automated_backups
    network_type = var.network_type
    create_cloudwatch_log_group = local.create_cloudwatch_log_group
    cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
    cloudwatch_log_group_kms_key_id = var.cloudwatch_log_group_kms_key_id

    cloudwatch_log_group_skip_destroy_on_deletion = local.cloudwatch_log_group_skip_destroy_on_deletion # not woeking??
    monitoring_iam_role_path = var.monitoring_iam_role_path

}

module "cluster" {
    count = var.is_db_cluster ? 1 : 0
    source = "../opensource_tf_modules//terraform-aws-rds-aurora"


    name = var.identifier

    # engine = var.engine
    # engine_version = var.engine_version


    # master_username = var.username
    # master_password = var.password
    # manage_master_user_password = var.manage_master_user_password

    tags = var.tags
    create_db_subnet_group = var.create_db_subnet_group
    db_subnet_group_name = var.db_subnet_group_name

    # subnets = var.subnets # we don't want to create db_subnet_group
    is_primary_cluster = var.cluster_is_primary_cluster
    cluster_use_name_prefix = var.cluster_use_name_prefix
    allocated_storage = var.allocated_storage
    allow_major_version_upgrade = var.allow_major_version_upgrade
    apply_immediately = var.apply_immediately
    availability_zones = var.cluster_availability_zones
    backup_retention_period = var.backup_retention_period
    backtrack_window = var.cluster_backtrack_window
    cluster_members = var.cluster_members
    copy_tags_to_snapshot = var.copy_tags_to_snapshot
    database_name  = var.db_name
    db_cluster_instance_class = local.instance_class
    db_cluster_db_instance_parameter_group_name = var.parameter_group_name # ?
    deletion_protection = var.deletion_protection
    enable_global_write_forwarding = var.cluster_enable_global_write_forwarding
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
    enable_http_endpoint = var.cluster_enable_http_endpoint
    engine = var.engine
    engine_mode = var.cluster_engine_mode
    engine_version = var.engine_version
    final_snapshot_identifier = local.final_snapshot_identifier # update var!
    global_cluster_identifier = var.cluster_global_cluster_identifier
    iam_database_authentication_enabled = var.iam_database_authentication_enabled
    iops = var.iops
    kms_key_id = var.kms_key_id
    manage_master_user_password = var.manage_master_user_password
    master_user_secret_kms_key_id = var.master_user_secret_kms_key_id
    master_password = var.password
    master_username = var.username
    network_type    = var.network_type
    port        = var.port
    preferred_backup_window = var.backup_window
    preferred_maintenance_window = var.maintenance_window
    replication_source_identifier   = var.cluster_replication_source_identifier
    restore_to_point_in_time = var.restore_to_point_in_time == null ? {} : var.restore_to_point_in_time
    s3_import = var.s3_import == null ? {} : var.s3_import
    scaling_configuration   = var.cluster_scaling_configuration # serverlessv2_scaling_configuration
    serverlessv2_scaling_configuration = var.cluster_serverlessv2_scaling_configuration
    skip_final_snapshot = var.skip_final_snapshot
    snapshot_identifier = var.snapshot_identifier
    source_region = var.cluster_source_region
    storage_encrypted = var.storage_encrypted
    storage_type    = var.storage_type
    cluster_tags    = var.cluster_tags # maybe not needed
    vpc_security_group_ids  = var.vpc_security_group_ids
    cluster_timeouts   = var.cluster_timeouts
    instances  = var.cluster_instances
    auto_minor_version_upgrade = var.auto_minor_version_upgrade
    ca_cert_identifier = var.ca_cert_identifier
    db_parameter_group_name = var.parameter_group_name # ?
    instances_use_identifier_prefix = var.cluster_instances_use_identifier_prefix
    instance_class = local.instance_class
    monitoring_interval = var.monitoring_interval
    performance_insights_enabled  = var.performance_insights_enabled
    performance_insights_kms_key_id = var.performance_insights_kms_key_id
    performance_insights_retention_period = var.performance_insights_retention_period
    publicly_accessible = var.publicly_accessible
    instance_timeouts = var.timeouts
    endpoints = var.cluster_endpoints
    iam_roles = var.cluster_iam_roles
    create_monitoring_role = var.create_monitoring_role
    monitoring_role_arn = var.monitoring_role_arn
    iam_role_name   = var.monitoring_role_arn
    iam_role_use_name_prefix    = var.monitoring_role_use_name_prefix
    iam_role_description   = var.monitoring_role_description
    iam_role_path = var.monitoring_iam_role_path
    iam_role_managed_policy_arns = null #var.iam_role_managed_policy_arns
    iam_role_permissions_boundary = var.monitoring_role_permissions_boundary
    iam_role_force_detach_policies = null #var.iam_role_force_detach_policies
    iam_role_max_session_duration = null # var.iam_role_max_session_duration
    autoscaling_enabled = var.cluster_autoscaling_enabled
    autoscaling_max_capacity = var.cluster_autoscaling_max_capacity
    autoscaling_min_capacity = var.cluster_autoscaling_min_capacity
    autoscaling_policy_name = var.cluster_autoscaling_policy_name
    predefined_metric_type = var.cluster_predefined_metric_type
    autoscaling_scale_in_cooldown = var.cluster_autoscaling_scale_in_cooldown
    autoscaling_scale_out_cooldown = var.cluster_autoscaling_scale_out_cooldown
    autoscaling_target_cpu = var.cluster_autoscaling_target_cpu
    autoscaling_target_connections = var.cluster_autoscaling_target_connections
    # create_security_group = var.create_security_group # Create a generic security group for RDS and Aurora
    # security_group_name = var.security_group_name
    # security_group_use_name_prefix = var.security_group_use_name_prefix
    # security_group_description  = var.security_group_description
    # vpc_id = var.vpc_id
    # security_group_rules = var.security_group_rules
    # security_group_tags = var.security_group_tags

    # create_db_cluster_parameter_group   = var.create_db_cluster_parameter_group # ?
    # db_cluster_parameter_group_name = var.db_cluster_parameter_group_name # ?
    # db_cluster_parameter_group_use_name_prefix = var.db_cluster_parameter_group_use_name_prefix
    # db_cluster_parameter_group_description  = var.db_cluster_parameter_group_description
    # db_cluster_parameter_group_family  = var.db_cluster_parameter_group_family
    # db_cluster_parameter_group_parameters   = var.db_cluster_parameter_group_parameters
    # create_db_parameter_group  = var.create_db_parameter_group
    # db_parameter_group_use_name_prefix  = var.db_parameter_group_use_name_prefix
    # db_parameter_group_description = var.db_parameter_group_description
    # db_parameter_group_family = var.db_parameter_group_family
    # db_parameter_group_parameters = var.db_parameter_group_parameters
    create_cloudwatch_log_group = local.create_cloudwatch_log_group
    cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
    cloudwatch_log_group_kms_key_id = var.cloudwatch_log_group_kms_key_id
    create_db_cluster_activity_stream   = var.create_db_cluster_activity_stream
    db_cluster_activity_stream_mode = var.cluster_activity_stream_mode
    db_cluster_activity_stream_kms_key_id = var.cluster_activity_stream_kms_key_id
    engine_native_audit_fields_included = var.cluster_engine_native_audit_fields_included


#   vpc_id               = module.vpc.vpc_id
#   db_subnet_group_name = module.vpc.database_subnet_group_name

#   enabled_cloudwatch_logs_exports = ["postgresql"]

#   # Multi-AZ
#   availability_zones        = module.vpc.azs
#   allocated_storage         = 256
#   db_cluster_instance_class = "db.r6gd.large"
#   iops                      = 2500
#   storage_type              = "io1"

#   skip_final_snapshot = true

#   tags = local.tags
}

#
# lightweight_db
# major_engine_version
# resource "aws_rds_cluster" "example" {
#   cluster_identifier        = "example"
#   availability_zones        = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   engine                    = "mysql"
#   db_cluster_instance_class = "db.r6gd.xlarge"
#   storage_type              = "io1"
#   allocated_storage         = 100
#   iops                      = 1000
#   master_username           = "test"
#   master_password           = "mustbeeightcharaters"
# }