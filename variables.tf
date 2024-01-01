# Expose vars for DB instance. Override defaults with sensible values for DFDS context

################################################################################
# Instance specific variables - applicable to cluster instances as well
################################################################################

variable "is_instance" { # TODO: Remove this variable if not used
  default = true
}

variable "environment" {
  description = <<EOF
    Specify the staging environment.
    Valid Values: "dev", "test", "staging", "uat", "training", "prod".
    Notes: The value will set configuration defaults according to DFDS policies.
EOF
  type        = string
  validation {
    condition     = contains(["dev", "test", "staging", "uat", "training", "prod"], var.environment)
    error_message = "Valid values for environment are: dev, test, staging, uat, training, prod."
  }
}

variable "identifier" {
  description = <<EOF
    Specify the name of the RDS instance to create.
    Valid Values: .
    Notes: .
EOF
  type        = string
}

variable "allocated_storage" {
  description = <<EOF
    Specify the allocated storage in gigabytes.
    Valid Values: .
    Notes: .
EOF
  type        = number
  default     = null
}

variable "storage_type" {
  description = <<EOF
    Specify the storage type.
    Valid Values: One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD).
    Notes: Default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter
EOF
  type        = string
  default     = "gp3"
}

variable "storage_throughput" { # TODO: What is See `notes`?
  description = <<EOF
    Speficy storage throughput value for the DB instance.
    Valid Values: .
    Notes: See `notes` for limitations regarding this variable for `gp3`.
EOF
  type        = number
  default     = null
}

variable "replicate_source_db" { # TODO: Consider providing abstraction to this
  description = <<EOF
    Inidicate that this resource is a Replicate database, and to use this value as the source database.
    Valid Values: The identifier of another Amazon RDS Database to replicate in the same region.
    Notes: In case of cross-region replication, specify the ARN of the source DB instance.
EOF
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = <<EOF
    Set this to true to enable authentication using IAM.
    Valid Values: .
    Notes: This requires creating mappings between IAM users/roles and database accounts in the RDS instance for this to work properly.
EOF
  type        = bool
  default     = false
}

variable "engine_version" {
  description = <<EOF
    Specify engine version to use.
    Valid Values: Specific version number, for example, "15.3" or major version number, for example, "15".
    Notes:
    - If this is omitted, the preffered version will be used.
    - If major version is specified, the preffered version will be used.
    - When using a specific version. The version must be valid. A valid  version can be obtained from this [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html)
EOF
  type        = string
  default     = null
}

variable "skip_final_snapshot" { # TODO: Check if this has been tested (Backup will remain in AWS Backup)
  description = <<EOF
    Setting this will determine whether a final DB snapshot is created before the DB instance is deleted.
    Valid Values: Specific version number, for example, "15.3" or major version number, for example, "15".
    Notes:
    - If true is specified, no DB Snapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted
    - Default value is set to true. Snapshots will be created by the AWS backup job assuming that this resource is properly tagged, see [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started) for more info.
EOF
  type        = bool
  default     = true
}

variable "source_snapshot_identifier" {
  description = <<EOF
    Provide the ID of the snapshot to create this instance from.
    Valid Values: This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"
    Notes: Setting this will cause the instance to restore from the specified snapshot.
EOF
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = <<EOF
    Specifies whether or not to copy all Instance tags to the final snapshot on deletion.
    Valid Values: .
    Notes: Default value is set to true. Snapshots will be created by the AWS backup job assuming that this resource is properly tagged, see [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started) for more info.
EOF
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = <<EOF
    Specifies the name which is prefixed to the final snapshot on cluster destroy.
    Valid Values: .
    Notes: .
EOF
  type        = string
  default     = "final"
}

variable "instance_class" {
  description = <<EOF
    Specify instance type of the RDS instance.
    Valid Values:
      "db.t3.micro",
      "db.t3.small",
      "db.t3.medium",
      "db.t3.large",
      "db.t3.xlarge",
      "db.t3.2xlarge",
      "db.r6g.xlarge",
      "db.m6g.large",
      "db.m6g.xlarge",
      "db.t2.micro",
      "db.t2.small",
      "db.t2.medium",
      "db.m4.large",
      "db.m5d.large",
      "db.m6i.large",
      "db.m5.xlarge",
      "db.t4g.micro",
      "db.t4g.small",
      "db.t4g.large",
      "db.t4g.xlarge"
    Notes: If omitted, the instance type will be set to db.t3.micro.
EOF
  type        = string
  default     = null
  validation {
    condition = var.instance_class == null ? true : (
      contains([
        "db.t3.micro",
        "db.t3.small",
        "db.t3.medium",
        "db.t3.large",
        "db.t3.xlarge",
        "db.t3.2xlarge",
        "db.r6g.xlarge",
        "db.m6g.large",
        "db.m6g.xlarge",
        "db.t2.micro",
        "db.t2.small",
        "db.t2.medium",
        "db.m4.large",
        "db.m5d.large",
        "db.m6i.large",
        "db.m5.xlarge",
        "db.t4g.micro",
        "db.t4g.small",
        "db.t4g.large",
        "db.t4g.xlarge"],
    var.instance_class) ? true : false)
    error_message = "The instance type is not allowed."
  }
}

variable "db_name" {
  description = <<EOF
    Specifies The DB name to create.
    Valid Values: .
    Notes: If omitted, no database is created initially
EOF
  type        = string
  default     = null
}

variable "username" {
  description = <<EOF
    Specify Username for the master DB user.
    Valid Values: .
    Notes: .
EOF
  type        = string
}

variable "password" {
  description = <<EOF
    Specify password for the master DB user.
    Valid Values: .
    Notes:
    - This password may show up in logs, and it will be stored in the state file.
    - If `manage_master_user_password` is set to true, this value will be ignored.
EOF
  type        = string
  default     = null
  sensitive   = true
}

variable "manage_master_user_password" {
  description = <<EOF
    Set to true to allow RDS to manage the master user password in Secrets Manager
    Valid Values: .
    Notes:
    - Default value is set to true. It is recommended to use this feature.
    - If set to true, the `password` variable will be ignored.
EOF
  type        = bool
  default     = true
}

variable "port" { # TODO: Set default value to 5432 and test after removing default value from locals.tf
  description = <<EOF
    Specify the port number on which the DB accepts connections.
    Valid Values: .
    Notes: If omitted, the port number will set to 5432.
EOF
  type        = string
  default     = null
}

variable "availability_zone" {
  description = <<EOF
    Specify the Availability Zone for the RDS instance..
    Valid Values:
    Notes: Only available for DB instances that do not have multi-AZ enabled.
EOF
  type        = string
  default     = null
}

variable "instance_is_multi_az" {
  description = <<EOF
    Specify if the RDS instance is multi-AZ.
    Valid Values: .
    Notes:
    - This creates a primary DB instance and a standby DB instance in a different AZ for high availability and data redundancy.
    - Standby DB instance doesn't support connections for read workloads.
    - If this variable is omitted:
      - This value is set to true by default for production environments.
      - This value is set to false by default for non-production environments.
EOF
  type        = bool
  default     = null
}

variable "iops" {
  description = <<EOF
    Specify The amount of provisioned IOPS.
    Valid Values: .
    Notes: Setting this implies a storage_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`"
EOF
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = <<EOF
    Specify whether or not this instance is publicly accessible.
    Valid Values: .
    Notes:
    - Setting this to true will do the followings:
      - Assign a public IP address and the host name of the DB instance will resolve to the public IP address.
      - Access from within the VPC can be achived by using the private IP address of the assigned Network Interface.
EOF
  type        = bool
  default     = false
}

variable "enhanced_monitoring_interval" {
  description = <<EOF
    Specify the interval between points when Enhanced Monitoring metrics are collected for the DB instance.
    Valid Values: 0, 1, 5, 10, 15, 30, 60 (in seconds)
    Notes: Specify 0 to disable collecting Enhanced Monitoring metrics.
EOF
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.enhanced_monitoring_interval)
    error_message = "Valid values for enhanced_monitoring_interval are: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "allow_major_version_upgrade" {
  description = <<EOF
    Specify whether or not that major version upgrades are allowed.
    Valid Values: .
    Notes: Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
EOF
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = <<EOF
    Specify whether or not that minor engine upgrades can be applied automatically to the DB instance".
    Valid Values: .
    Notes: Minor engine upgrades will be applied automatically to the DB instance during the maintenance window.
EOF
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = <<EOF
    Specifiy whether any database modifications are applied immediately, or during the next maintenance window
    Valid Values: .
    Notes: apply_immediately can result in a brief downtime as the server reboots. See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html) for more information.
EOF
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = <<EOF
    Specify the window to perform maintenance in.
    Valid Values: Syntax: `ddd:hh24:mi-ddd:hh24:mi`. Eg: `"Mon:00:00-Mon:03:00"`.
    Notes: Default value is set to `"Sat:18:00-Sat:20:00"`. This is adjusted in accordance with AWS Backup schedule, see info [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started).
EOF
  type        = string
  default     = "Sat:18:00-Sat:20:00"
  validation {
    condition     = can(regex("^([a-zA-Z]{3}):([0-2][0-9]):([0-5][0-9])-([a-zA-Z]{3}):([0-2][0-9]):([0-5][0-9])$", var.maintenance_window))
    error_message = "Maintenance window must be in the format 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  }
}


variable "subnet_ids" {
  description = <<EOF
    Provide a list of VPC subnet IDs.
    Valid Values: .
    Notes: IDs of the subnets must be in the same VPC as the RDS instance.
EOF
  type        = list(string)
}

variable "instance_parameters" {
  description = <<EOF
    Specify a list of DB parameters (map) to modify.
    Valid Values: Example:
      instance_parameters = [{
          name         = "rds.force_ssl"
          value        = 1
          apply_method = "pending-reboot",
          ... # Other parameters
        }]
    Notes: See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters) for more information.
EOF
  type        = list(map(string))
  default     = []
}

variable "create_db_instance" { # TODO: Remove
  description = "Whether to create a database instance"
  type        = bool
  default     = true
}


variable "instance_terraform_timeouts" {
  description = <<EOF
    Specify Terraform resource management timeouts.
    Valid Values: .
    Notes: Applies to `aws_db_instance` in particular to permit resource management times. See [documentation](https://www.terraform.io/docs/configuration/resources.html#operation-timeouts) for more information.
EOF
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = <<EOF
    Specify whether or not to prevent the DB instance from being deleted.
    Valid Values: .
    Notes: The database can't be deleted when this value is set to true.
EOF
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = <<EOF
    Specify whether or not to enable Performance Insights.
    Valid Values: .
    Notes:
    - If this variable is omitted:
      - This value is set to true by default for production environments. Default retention period is set to 7 days.
      - This value is set to false by default for non-production environments.
EOF
  type        = bool
  default     = null
}

variable "performance_insights_retention_period" { # TODO: Set default value to 7 and test after removing default value (null) from locals.tf
  description = <<EOF
    Specify the retention period for Performance Insights.
    Valid Values: `7`, `731` (2 years) or a multiple of `31`
    Notes: Set the value Default value when `performance_insights_enabled` is set to true.
EOF
  type        = number
  default     = null
}

variable "performance_insights_kms_key_id" {
  description = <<EOF
    Specify the ARN for the KMS key to encrypt Performance Insights data.
    Valid Values: .
    Notes:
      - When specifying performance_insights_kms_key_id, performance_insights_enabled needs to be set to true.
      - Once KMS key is set, it can never be changed
EOF
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = <<EOF
    Set the value to enable Storage Autoscaling and to set the max allocated storage.
    Valid Values: .
    Notes:
    - If this variable is omitted:
      - This value is set to 50 by default for production environments.
      - This value is set to 0 by default for non-production environments.
EOF
  type        = number
  default     = null
}

variable "ca_cert_identifier" {
  description = <<EOF
    Specify the identifier of the CA certificate for the DB instance.
    Valid Values: .
    Notes: If this variable is omitted, the latest CA certificate will be used.
EOF
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = <<EOF
    Specify whether or not whether to remove automated backups immediately after the DB instance is deleted.
    Valid Values: .
    Notes: .
EOF
  type        = bool
  default     = true
}

variable "network_type" {
  description = <<EOF
    Specify the network type of the DB instance.
    Valid Values: IPV4, DUAL
    Notes: .
EOF
  type        = string
  default     = null
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "enabled_cloudwatch_logs_exports" {
  description = <<EOF
    Specify the list of log types to enable for exporting to CloudWatch logs.
    Valid Values: postgresql (PostgreSQL), upgrade (PostgreSQL)
    Notes: If omitted, no logs will be exported.
EOF
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
  description = <<EOF
    Specify the retention period in days for the CloudWatch logs.
    Valid Values: Number of days
    Notes: .
EOF
  type        = number
  default     = 1
}

variable "cloudwatch_log_group_kms_key_id" {
  description = <<EOF
    Specify the ARN of the KMS Key to use when encrypting log data.
    Valid Values: .
    Notes: .
EOF
  type        = string
  default     = null
}

variable "cloudwatch_log_group_skip_destroy_on_deletion" {
  description = <<EOF
    Specify whether or not to skip the deletion of the CloudWatch log group on deletion.
    Valid Values: .
    Notes: .
EOF
  type        = bool
  default     = false
}

################################################################################
# Cluster specific variables
################################################################################

variable "is_cluster" {
  type    = bool
  default = false
}

variable "cluster_is_primary_cluster" { # TODO: Remove if not needed
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

variable "cluster_scaling_configuration" { # TODO: Prefix with serverless
  description = "Map of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "cluster_serverlessv2_scaling_configuration" { # TODO: Prefix with serverless
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

variable "cluster_instances_use_identifier_prefix" { # TODO: Remove if not needed
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

variable "is_proxy_included" {
  description = <<EOF
    Specify whether or not to include proxy.
    Valid Values: .
    Notes: Proxy helps managing database connections. See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-planning.html) for more information.
EOF
  type        = bool
  default     = false
}

variable "proxy_debug_logging_is_enabled" {
  description = <<EOF
    Turn on debug logging for the proxy.
    Valid Values: .
    Notes: .
EOF
  default     = false
  type        = bool
}

variable "proxy_idle_client_timeout" {
  description = <<EOF
    Specify idle client timeout of the RDS proxy (keep connection alive).
    Valid Values: .
    Notes: .
EOF
  default     = 1800
  type        = number
}

variable "proxy_require_tls" {
  description = <<EOF
    Specify whether or not to require TLS for the proxy.
    Valid Values: .
    Notes: Default value is set to true.
EOF
  type        = bool
  default     = true
}

variable "proxy_engine_family" { # TODO: Remove if not needed
  description = <<EOF
    Specify engine family of the RDS proxy.
    Valid Values: POSTGRESQL
    Notes: .
EOF
  type        = string
  default     = "POSTGRESQL"
  validation {
    condition     = contains(["POSTGRESQL"], var.proxy_engine_family)
    error_message = "Invalid value for var.proxy_engine_family. Supported value: POSTGRESQL."
  }
}

variable "proxy_security_group_rules" {
  description = <<EOF
    Specify additional security group rules for the RDS proxy.
    Valid Values: .
    Notes:
    - Only ingress(inbound) rules are supported.
    - Ingress rules are set to "Allow outbound traffic to PostgreSQL instance"
    – Ingress rules are set to "Allow inbound traffic from same security group on specified database port"
EOF
  type = object({
    ingress_rules     = list(any)
    ingress_with_self = optional(list(any), [])
  })
  default = {
    ingress_rules = []
  }
}

variable "proxy_iam_auth" {
  description = <<EOF
    Specify whether or not to use IAM authentication for the proxy.
    Valid Values: DISABLED, REQUIRED
    Notes: .
EOF
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["DISABLED", "REQUIRED"], var.proxy_iam_auth)
    error_message = "Invalid value for var.proxy_iam_auth. Supported values: DISABLED, REQUIRED."
  }
}

variable "is_serverless" { # temporary variable for testing
  type    = bool
  default = false
}


################################################################################
# Security Group
################################################################################

variable "vpc_id" {
  description = <<EOF
    Specify the VPC ID.
    Valid Values: .
    Notes: .
EOF
  type        = string
}

variable "rds_security_group_rules" {
  description = <<EOF
    Specify additional security group rules for the RDS instance.
    Valid Values: .
    Notes: .
EOF
  type = object({
    ingress_rules     = list(any)
    ingress_with_self = optional(list(any), [])
    egress_rules      = optional(list(any), [])
  })
}

# ################################################################################
# # IAM Roles for ServiceAccounts (IRSA) - only applicable from Kubernetes pods
# ################################################################################

variable "is_kubernetes_app_enabled" {
  description = <<EOF
    Specify whether or not to enable access from Kubernetes pods.
    Valid Values: .
    Notes: Enabling this will create the following resources:
      - IAM role for service account (IRSA)
      - IAM policy for service account (IRSA)
EOF
  type        = bool
  default     = false
}

################################################################################
# Resource tagging
################################################################################

variable "resource_owner_contact_email" {
  description = <<EOF
    Provide an email address for the resource owner (e.g. team or individual).
    Valid Values: .
    Notes: This set the dfds.owner tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF

  type    = string
  default = null
  validation {
    condition     = var.resource_owner_contact_email == null || can(regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", var.resource_owner_contact_email))
    error_message = "Invalid value for var.resource_owner_contact_email. Must be a valid email address."
  }
}

variable "cost_centre" {
  description = <<EOF
    Provide a cost centre for the resource.
    Valid Values: .
    Notes: This set the dfds.cost_centre tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = string
}

variable "enable_default_backup" {
  description = <<EOF
    Specify whether or not to enable default backup.
    Valid Values: .
    Notes: This set the dfds.backup tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = bool
  default     = null
}

variable "additional_backup_retention" {
  description = <<EOF
    Specify additional backup retention.
    Valid Values: 30days, 60days, 180days, 1year, 10year
    Notes: This set the dfds.backup_retention tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = string
  default     = null
  validation {
    condition = var.additional_backup_retention == null ? true : (
      contains(["30days", "60days", "180days", "1year", "10year"], var.additional_backup_retention) ? true : false
    )
    error_message = "Invalid value for var.additional_backup_retention. Supported values: 30days, 60days, 180days, 1year, 10year."
  }
}

variable "data_classification" {
  description = <<EOF
    Specify data classification.
    Valid Values: public, private, confidential, restricted
    Notes: This set the dfds.data.classification tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = string
  validation {
    condition     = contains(["public", "private", "confidential", "restricted"], var.data_classification)
    error_message = "Invalid value for var.data_classification. Supported values: public, private, confidential, restricted."
  }
}

variable "service_availability" {
  description = <<EOF
    Specify service availability.
    Valid Values: low, medium, high
    Notes: This set the dfds.service.availability tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = string
  validation {
    condition     = contains(["low", "medium", "high"], var.service_availability)
    error_message = "Invalid value for var.service_availability. Supported values: low, medium, high."
  }
}

variable "optional_data_specific_tags" {
  description = <<EOF
    Provide list of optional dfds.data.* to be applied on data specific resources.
    Valid Values: .
    Notes:
    - Use this only for optional data tags. Required tags are supplied through dedicated variables.
    - This variable will apply tags only on the relevant data resources.
    - See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = <<EOF
    Provide list of optional dfds.* tags to be applied on all resources.
    Valid Values: .
    Notes:
    - Use this only for optional tags. Required tags are supplied through dedicated variables.
    - See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = map(string)
  default     = {}
}

variable "pipeline_location" { # TODO: Consider making it required. Consider how to support run from local machine. Re-Test validation.
  description = <<EOF
    Specify a valid URL path to the file used for automation script.
    Valid Values: URL to repo. Example: `"https://github.com/dfds/aws-modules-rds/actions/workflows/qa.yml"`
    Notes: This set the dfds.automation.initiator.pipeline tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).
EOF
  type        = string
  default     = null
  validation {
    condition     = var.pipeline_location == null || can(regex("^(https:\\/\\/www\\.|http:\\/\\/www\\.|https:\\/\\/|http:\\/\\/)?[a-zA-Z0-9]{2,}(\\.[a-zA-Z0-9]{2,})([a-z0-9_@\\-^!#$%&+={}.\\/\\\\[\\]]+)+\\.(yml|yaml|sh)$", var.pipeline_location))
    error_message = "Invalid value for var.pipeline_location. Supported values: URL path. Example: https://github.com/dfds/aws-modules-rds/actions/workflows/qa.yml"
  }
}
