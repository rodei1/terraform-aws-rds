# Expose vars for DB instance. Override defaults with sensible values for DFDS context

################################################################################
# Instance specific variables - applicable to cluster instances as well
################################################################################

variable "environment" {
  description = "The environment"
  type        = string
  validation {
    condition     = contains(["dev", "test", "staging", "uat", "training", "prod"], var.environment)
    error_message = "Valid values for environment are: dev, test,staging, uat, training, prod."
  }
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "instance_use_identifier_prefix" {
  description = "Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
  default     = "gp3"
}

variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used. Be sure to use the full ARN, not a key alias."
  type        = string
  default     = null
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate"
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in"
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "(Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use. If not specified the preffered version will be used. It is also possible to pass major version in this format \"15\". Note: that a specific version must be valid and this can be obtained from this documentation: https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true # Snapshots are already created by the AWS backup job.
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "db.t3.micro", "db.t3.small", "db.t3.medium", "db.t3.large", "db.t3.xlarge", "db.t3.2xlarge", "db.r6g.xlarge", "db.m6g.large", "db.m6g.xlarge", "db.t2.micro", "db.t2.small", "db.t2.medium", "db.m4.large", "db.m5d.large", "db.m6i.large", "db.m5.xlarge", "db.t4g.micro", "db.t4g.small", "db.t4g.large", "db.t4g.xlarge"], var.instance_class)
    error_message = "The instance type is not allowed."
  }
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
}

variable "password" {
  description = <<EOF
  Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.
  The password provided will not be used if `manage_master_user_password` is set to true.
  EOF
  type        = string
  default     = null
  sensitive   = true
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}

variable "master_user_secret_kms_key_id" {
  description = <<EOF
  The key ARN, key ID, alias ARN or alias name for the KMS key to encrypt the master user password secret in Secrets Manager.
  If not specified, the default KMS key for your Amazon Web Services account is used.
  EOF
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections. If not set it will be 5432"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = null
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "enhanced_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  type        = number
  default     = 0
}

variable "enhanced_monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero"
  type        = string
  default     = null
}

variable "enhanced_monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled"
  type        = string
  default     = null
}

variable "enhanced_monitoring_role_use_name_prefix" {
  description = "Determines whether to use `monitoring_role_name` as is or create a unique identifier beginning with `monitoring_role_name` as the specified prefix"
  type        = bool
  default     = false
}

variable "enhanced_monitoring_role_description" {
  description = "Description of the monitoring IAM role"
  type        = string
  default     = null
}

variable "enhanced_monitoring_create_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = bool
  default     = false
}

variable "enhanced_monitoring_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the monitoring IAM role"
  type        = string
  default     = null
}

variable "enhanced_monitoring_iam_role_path" {
  description = "Path for the monitoring role"
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" { # TODO: Need validation. Use regex?
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sat:18:00-Sat:20:00" # This is adjusted in accordance with AWS Backup schedule, see info here: https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started
  validation {
    condition     = can(regex("^([a-zA-Z]{3}):([0-2][0-9]):([0-5][0-9])-([a-zA-Z]{3}):([0-2][0-9]):([0-5][0-9])$", var.maintenance_window))
    error_message = "Maintenance window must be in the format 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  }
}
# Continuous backup takes place between 8 PM and 5 AM UTC.
# Snapshot backups take place between 3 AM and 7 AM UTC.

variable "blue_green_update" {
  description = "Enables low-downtime updates using RDS Blue/Green deployments."
  type        = map(string)
  default     = {}
}

variable "restore_to_point_in_time" {
  description = "Restore to a point in time (MySQL is NOT supported)"
  type        = map(string)
  default     = null
}

variable "s3_import" {
  description = "Restore from a Percona Xtrabackup in S3 (only MySQL is supported)"
  type        = map(string)
  default     = null
}

variable "create_db_subnet_group" {
  description = "Whether to create a DB subnet group"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null # required # it can be null ?
}

# TODO: Remove
variable "db_subnet_group_use_name_prefix" {
  description = "Determines whether to use `subnet_group_name` as is or create a unique name beginning with the `subnet_group_name` as the prefix"
  type        = bool
  default     = false
}
# TODO: Remove
variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}

# DB parameter group
variable "create_db_parameter_group" { # Test this
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}

variable "parameter_group_use_name_prefix" { # It is good to have default value as true in case of upgrades as it results in new parameter group to be created with new engine version
  description = "Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = null
}

variable "parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null # varies depending on engine and version and instance type
}

variable "instance_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

# DB option group
variable "create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = true
}

variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}

variable "option_group_use_name_prefix" {
  description = "Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "create_db_instance" {
  description = "Whether to create a database instance"
  type        = bool
  default     = true
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information"
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation"
  type        = string
  default     = null
}

variable "nchar_character_set_name" {
  description = "The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances. This can't be changed."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default     = {}
}

variable "option_group_timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = null
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31`"
  type        = number
  default     = null
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "network_type" {
  description = "The type of network stack to use"
  type        = string
  default     = null
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values postgresql (PostgreSQL), upgrade (PostgreSQL)"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for s in var.enabled_cloudwatch_logs_exports : contains(["postgresql", "upgrade"], s)
    ])
    error_message = "value must be either postgresql or upgrade."
  }
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 1
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_skip_destroy_on_deletion" {
  description = "Should we skip to destroy CloudWatch log group on deletion?"
  type        = bool
  default     = false
}

################################################################################
# Cluster specific variables
################################################################################

variable "is_db_cluster" {
  type    = bool
  default = false
}

variable "cluster_is_primary_cluster" {
  description = "Determines whether cluster is primary cluster with writer instance (set to `false` for global cluster and replica clusters)"
  type        = bool
  default     = true
}

variable "cluster_use_name_prefix" {
  description = "Whether to use `name` as a prefix for the cluster"
  type        = bool
  default     = false
}

variable "cluster_availability_zones" {
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply"
  type        = list(string)
  default     = null
}

variable "cluster_backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for `aurora` engine currently. To disable backtracking, set this value to 0. Must be between 0 and 259200 (72 hours)"
  type        = number
  default     = null
}

variable "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  type        = list(string)
  default     = null
}

variable "cluster_enable_global_write_forwarding" {
  description = "Whether cluster should forward writes to an associated global cluster. Applied to secondary clusters to enable them to forward writes to an `aws_rds_global_cluster`'s primary cluster"
  type        = bool
  default     = null
}

variable "cluster_enable_http_endpoint" {
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to `serverless`"
  type        = bool
  default     = null
}

# variable "cluster_engine_mode" {
#   description = "The database engine mode. Valid values: `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless`. Defaults to: `provisioned`"
#   type        = string
#   default     = "provisioned"
# }

variable "cluster_global_cluster_identifier" {
  description = "The global cluster identifier specified on `aws_rds_global_cluster`"
  type        = string
  default     = null
}

variable "cluster_replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  type        = string
  default     = null
}

variable "cluster_scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "cluster_serverlessv2_scaling_configuration" {
  description = "Map of nested attributes with serverless v2 scaling properties. Only valid when `engine_mode` is set to `provisioned`"
  type        = map(string)
  default     = {}
}

variable "cluster_source_region" {
  description = "The source region for an encrypted replica DB cluster"
  type        = string
  default     = null
}

variable "cluster_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default     = {}
}

variable "cluster_db_instance_count" {
  type    = number
  default = 0
}

variable "cluster_instances_use_identifier_prefix" {
  description = "Determines whether cluster instance identifiers are used as prefixes"
  type        = bool
  default     = false
}


variable "cluster_endpoints" {
  description = "Map of additional cluster endpoints and their attributes to be created"
  type        = any
  default     = {}
}


variable "cluster_iam_roles" { # ? custom_iam_instance_profile ??
  description = "Map of IAM roles and supported feature names to associate with the cluster"
  type        = map(map(string))
  default     = {}
}

variable "cluster_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

################################################################################
# Cluster Autoscaling
################################################################################

variable "cluster_autoscaling_enabled" {
  description = "Determines whether autoscaling of the cluster read replicas is enabled"
  type        = bool
  default     = false
}

variable "cluster_autoscaling_max_capacity" {
  description = "Maximum number of read replicas permitted when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "cluster_autoscaling_min_capacity" {
  description = "Minimum number of read replicas permitted when autoscaling is enabled"
  type        = number
  default     = 0
}

variable "cluster_autoscaling_policy_name" {
  description = "Autoscaling policy name"
  type        = string
  default     = "target-metric"
}

variable "cluster_predefined_metric_type" {
  description = "The metric type to scale on. Valid values are `RDSReaderAverageCPUUtilization` and `RDSReaderAverageDatabaseConnections`"
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
}

variable "cluster_autoscaling_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "cluster_autoscaling_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "cluster_autoscaling_target_cpu" {
  description = "CPU threshold which will initiate autoscaling"
  type        = number
  default     = 70
}

variable "cluster_autoscaling_target_connections" {
  description = "Average number of connections threshold which will initiate autoscaling. Default value is 70% of db.r4/r5/r6g.large's default max_connections"
  type        = number
  default     = 700
}

################################################################################
# Cluster Activity Stream
################################################################################

variable "create_db_cluster_activity_stream" {
  description = "Determines whether a cluster activity stream is created."
  type        = bool
  default     = false
}

variable "cluster_activity_stream_mode" {
  description = "Specifies the mode of the database activity stream. Database events such as a change or access generate an activity stream event. One of: sync, async"
  type        = string
  default     = null
}

variable "cluster_activity_stream_kms_key_id" {
  description = "The AWS KMS key identifier for encrypting messages in the database activity stream"
  type        = string
  default     = null
}

variable "cluster_engine_native_audit_fields_included" {
  description = "Specifies whether the database activity stream includes engine-native audit fields. This option only applies to an Oracle DB instance. By default, no engine-native audit fields are included"
  type        = bool
  default     = false
}


################################################################################
# Proxy settings
################################################################################

variable "include_proxy" {
  description = "Optionally include proxy to help manage database connections"
  type        = bool
  default     = false
}

variable "proxy_debug_logging" {
  description = "Turn on debug logging for the proxy"
  default     = false
}

variable "idle_client_timeout" {
  description = "Idle client timeout of the RDS proxy (keep connection alive)"
  default     = 1800
}

variable "proxy_require_tls" {
  description = "Require tls on the RDS proxy. Default: true"
  type        = bool
  default     = true
}

variable "proxy_name" {
  description = "Name of the RDS proxy. Will be auto-generated if not specified"
  type        = string
  default     = null
}

variable "proxy_engine_family" {
  description = "Engine family of the RDS proxy. Default: POSTGRESQL"
  type        = string
  default     = "POSTGRESQL"
  validation {
    condition     = contains(["POSTGRESQL"], var.proxy_engine_family)
    error_message = "Invalid value for var.proxy_engine_family. Supported value: POSTGRESQL."
  }
}

variable "proxy_security_group_rules" {
  type = object({
    ingress_rules     = list(any)
    ingress_with_self = optional(list(any), [])
  })
  default = {
    ingress_rules = []
  }
}

variable "rds_proxy_iam_auth" {
  type    = string
  default = "DISABLED"
  validation {
    condition     = contains(["DISABLED", "REQUIRED"], var.rds_proxy_iam_auth)
    error_message = "Invalid value for var.rds_proxy_iam_auth. Supported values: DISABLED, REQUIRED."
  }
}

variable "is_serverless" { # tempprary variable for testing
  type    = bool
  default = false
}


################################################################################
# Security Group
################################################################################

variable "vpc_id" {
  type = string
}

variable "rds_security_group_rules" {
  type = object({
    ingress_rules     = list(any)
    ingress_with_self = optional(list(any), [])
  })
}


# ################################################################################
# # IAM Roles for ServiceAccounts (IRSA) - only applicable from Kubernetes pods
# ################################################################################


variable "is_kubernetes_app_enabled" {
  description = "Determines whether to create needed resources to enable access from Kubernetes"
  type        = bool
  default     = false
}

################################################################################
# Resource tagging
################################################################################

variable "resource_owner_contact_email" {
  description = "Sets the dfds.owner tag"
  type        = string
  default     = null
  validation {
    condition     = var.resource_owner_contact_email == null || can(regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", var.resource_owner_contact_email))
    error_message = "Invalid value for var.resource_owner_contact_email. Must be a valid email address."
  }
}

variable "cost_centre" {
  description = "Sets the dfds.cost_centre tag. See recommendations here: https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy"
  type        = string
}

variable "enable_default_backup" {
  description = "Sets the dfds.data.backup tag to true on non-prod resources. Tag is set to true for prod and false for non-prod. Default backup retention is 30 days Point-in-time. More info here https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy"
  type        = bool
  default     = null
}

variable "additional_backup_retention" {
  description = "Sets the dfds.data.backup_retention tag to the specified value. See recommendations here: https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy. For additional info on how backup works see https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started"
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "30days", "60days", "180days", "1year", "10year"], var.additional_backup_retention)
    error_message = "Invalid value for var.additional_backup_retention. Supported values: 30days, 60days, 180days, 1year, 10year."
  }
}

variable "data_classification" {
  description = "Sets the dfds.data.classification tag to the specified value. See recommendations here: https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy"
  type        = string
  validation {
    condition     = contains(["public", "private", "confidential", "restricted"], var.data_classification)
    error_message = "Invalid value for var.data_classification. Supported values: public, private, confidential, restricted."
  }
}

variable "service_availability" {
  description = "Sets the dfds.service.availability tag to the specified value. See recommendations here: https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy"
  type        = string
  validation {
    condition     = contains(["low", "medium", "high"], var.service_availability)
    error_message = "Invalid value for var.service_availability. Supported values: low, medium, high."
  }
}

variable "optional_data_specific_tags" {
  description = <<EOF
    Provide list of tags that are prefixed with dfds.data.* tags on data resources.
    Use this variable to ensure that they get applied on the relevant data resources. See here for recommended and opitonal tags: https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy.
    Note: Required tags are supplied through dedicated variables.
EOF
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = "Sets the dfds.* tags on all resources"
  type        = map(string)
  default     = {}
}
