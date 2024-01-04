# This file is temporary. As supporting the cluster option for RDS instances is not part of the initial scope, this file contains the variables that could be used in the future.
# Still the main variable.tf file contains a few variables in regards to cluster, kept as they are needed for the module to function properly.
# Additionally, to prevent any accidental variable usage all of them are commented out.


# variable "cluster_is_primary_cluster" { # TODO: Remove if not needed
#   description = "Determines whether cluster is primary cluster with writer instance (set to `false` for global cluster and replica clusters)"
#   type        = bool
#   default     = true
# }

# variable "cluster_availability_zones" {
#   description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply"
#   type        = list(string)
#   default     = null
# }

# variable "cluster_backtrack_window" {
#   description = "The target backtrack window, in seconds. Only available for `aurora` engine currently. To disable backtracking, set this value to 0. Must be between 0 and 259200 (72 hours)"
#   type        = number
#   default     = null
# }

# variable "cluster_members" {
#   description = "List of RDS Instances that are a part of this cluster"
#   type        = list(string)
#   default     = null
# }

# variable "cluster_enable_global_write_forwarding" {
#   description = "Whether cluster should forward writes to an associated global cluster. Applied to secondary clusters to enable them to forward writes to an `aws_rds_global_cluster`'s primary cluster"
#   type        = bool
#   default     = null
# }

# variable "cluster_enable_http_endpoint" {
#   description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to `serverless`"
#   type        = bool
#   default     = null
# }

# # variable "cluster_engine_mode" {
# #   description = "The database engine mode. Valid values: `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless`. Defaults to: `provisioned`"
# #   type        = string
# #   default     = "provisioned"
# # }

# variable "cluster_global_cluster_identifier" {
#   description = "The global cluster identifier specified on `aws_rds_global_cluster`"
#   type        = string
#   default     = null
# }

# variable "cluster_replication_source_identifier" {
#   description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
#   type        = string
#   default     = null
# }

# variable "cluster_scaling_configuration" { # TODO: Prefix with serverless
#   description = "Map of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
#   type        = map(string)
#   default     = {}
# }

# variable "cluster_serverlessv2_scaling_configuration" { # TODO: Prefix with serverless
#   description = "Map of nested attributes with serverless v2 scaling properties. Only valid when `engine_mode` is set to `provisioned`"
#   type        = map(string)
#   default     = {}
# }

# variable "cluster_source_region" {
#   description = "The source region for an encrypted replica DB cluster"
#   type        = string
#   default     = null
# }

# variable "cluster_timeouts" {
#   description = "Create, update, and delete timeout configurations for the cluster"
#   type        = map(string)
#   default     = {}
# }

# variable "cluster_instances" {
#   description = "Map of cluster instances and any specific/overriding attributes to be created"
#   type        = any
#   default     = {}
# }

# variable "cluster_db_instance_count" {
#   type    = number
#   default = 0
# }

# variable "cluster_instances_use_identifier_prefix" { # TODO: Remove if not needed
#   description = "Determines whether cluster instance identifiers are used as prefixes"
#   type        = bool
#   default     = false
# }


# variable "cluster_endpoints" {
#   description = "Map of additional cluster endpoints and their attributes to be created"
#   type        = any
#   default     = {}
# }


# variable "cluster_iam_roles" { # ? custom_iam_instance_profile ??
#   description = "Map of IAM roles and supported feature names to associate with the cluster"
#   type        = map(map(string))
#   default     = {}
# }