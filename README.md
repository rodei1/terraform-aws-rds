# aws-modules-rds
Terraform module for AWS RDS instances

# Documentation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_parameters"></a> [cluster\_parameters](#module\_cluster\_parameters) | ./modules/cluster_parameter_group | n/a |
| <a name="module_cw_log_group"></a> [cw\_log\_group](#module\_cw\_log\_group) | ./modules/cloudwatch_log_groups | n/a |
| <a name="module_db_cluster_serverless"></a> [db\_cluster\_serverless](#module\_db\_cluster\_serverless) | ./modules/rds_aurora | n/a |
| <a name="module_db_instance"></a> [db\_instance](#module\_db\_instance) | ./modules/rds_instance | n/a |
| <a name="module_db_multi_az_cluster"></a> [db\_multi\_az\_cluster](#module\_db\_multi\_az\_cluster) | ./modules/rds_aurora | n/a |
| <a name="module_db_parameter_group"></a> [db\_parameter\_group](#module\_db\_parameter\_group) | ./modules/instance_parameter_group | n/a |
| <a name="module_db_proxy"></a> [db\_proxy](#module\_db\_proxy) | ./modules/rds_proxy | n/a |
| <a name="module_db_subnet_group"></a> [db\_subnet\_group](#module\_db\_subnet\_group) | ./modules/rds_subnet_group | n/a |
| <a name="module_enhanced_monitoring_iam_role"></a> [enhanced\_monitoring\_iam\_role](#module\_enhanced\_monitoring\_iam\_role) | ./modules/enhanced_monitoring_role | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ./modules/security_group | n/a |
| <a name="module_security_group_proxy"></a> [security\_group\_proxy](#module\_security\_group\_proxy) | ./modules/security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.validate_instance_type_proxy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.snapshot_identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_rds_engine_version.engine_info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `number` | `null` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The Availability Zone of the RDS instance | `string` | `null` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `null` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window | `string` | `null` | no |
| <a name="input_blue_green_update"></a> [blue\_green\_update](#input\_blue\_green\_update) | Enables low-downtime updates using RDS Blue/Green deployments. | `map(string)` | `{}` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance | `string` | `null` | no |
| <a name="input_character_set_name"></a> [character\_set\_name](#input\_character\_set\_name) | The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | The number of days to retain CloudWatch logs for the DB instance | `number` | `1` | no |
| <a name="input_cluster_activity_stream_kms_key_id"></a> [cluster\_activity\_stream\_kms\_key\_id](#input\_cluster\_activity\_stream\_kms\_key\_id) | The AWS KMS key identifier for encrypting messages in the database activity stream | `string` | `null` | no |
| <a name="input_cluster_activity_stream_mode"></a> [cluster\_activity\_stream\_mode](#input\_cluster\_activity\_stream\_mode) | Specifies the mode of the database activity stream. Database events such as a change or access generate an activity stream event. One of: sync, async | `string` | `null` | no |
| <a name="input_cluster_autoscaling_enabled"></a> [cluster\_autoscaling\_enabled](#input\_cluster\_autoscaling\_enabled) | Determines whether autoscaling of the cluster read replicas is enabled | `bool` | `false` | no |
| <a name="input_cluster_autoscaling_max_capacity"></a> [cluster\_autoscaling\_max\_capacity](#input\_cluster\_autoscaling\_max\_capacity) | Maximum number of read replicas permitted when autoscaling is enabled | `number` | `2` | no |
| <a name="input_cluster_autoscaling_min_capacity"></a> [cluster\_autoscaling\_min\_capacity](#input\_cluster\_autoscaling\_min\_capacity) | Minimum number of read replicas permitted when autoscaling is enabled | `number` | `0` | no |
| <a name="input_cluster_autoscaling_policy_name"></a> [cluster\_autoscaling\_policy\_name](#input\_cluster\_autoscaling\_policy\_name) | Autoscaling policy name | `string` | `"target-metric"` | no |
| <a name="input_cluster_autoscaling_scale_in_cooldown"></a> [cluster\_autoscaling\_scale\_in\_cooldown](#input\_cluster\_autoscaling\_scale\_in\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale in | `number` | `300` | no |
| <a name="input_cluster_autoscaling_scale_out_cooldown"></a> [cluster\_autoscaling\_scale\_out\_cooldown](#input\_cluster\_autoscaling\_scale\_out\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale out | `number` | `300` | no |
| <a name="input_cluster_autoscaling_target_connections"></a> [cluster\_autoscaling\_target\_connections](#input\_cluster\_autoscaling\_target\_connections) | Average number of connections threshold which will initiate autoscaling. Default value is 70% of db.r4/r5/r6g.large's default max\_connections | `number` | `700` | no |
| <a name="input_cluster_autoscaling_target_cpu"></a> [cluster\_autoscaling\_target\_cpu](#input\_cluster\_autoscaling\_target\_cpu) | CPU threshold which will initiate autoscaling | `number` | `70` | no |
| <a name="input_cluster_availability_zones"></a> [cluster\_availability\_zones](#input\_cluster\_availability\_zones) | List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply | `list(string)` | `null` | no |
| <a name="input_cluster_backtrack_window"></a> [cluster\_backtrack\_window](#input\_cluster\_backtrack\_window) | The target backtrack window, in seconds. Only available for `aurora` engine currently. To disable backtracking, set this value to 0. Must be between 0 and 259200 (72 hours) | `number` | `null` | no |
| <a name="input_cluster_db_instance_count"></a> [cluster\_db\_instance\_count](#input\_cluster\_db\_instance\_count) | n/a | `number` | `0` | no |
| <a name="input_cluster_enable_global_write_forwarding"></a> [cluster\_enable\_global\_write\_forwarding](#input\_cluster\_enable\_global\_write\_forwarding) | Whether cluster should forward writes to an associated global cluster. Applied to secondary clusters to enable them to forward writes to an `aws_rds_global_cluster`'s primary cluster | `bool` | `null` | no |
| <a name="input_cluster_enable_http_endpoint"></a> [cluster\_enable\_http\_endpoint](#input\_cluster\_enable\_http\_endpoint) | Enable HTTP endpoint (data API). Only valid when engine\_mode is set to `serverless` | `bool` | `null` | no |
| <a name="input_cluster_endpoints"></a> [cluster\_endpoints](#input\_cluster\_endpoints) | Map of additional cluster endpoints and their attributes to be created | `any` | `{}` | no |
| <a name="input_cluster_engine_native_audit_fields_included"></a> [cluster\_engine\_native\_audit\_fields\_included](#input\_cluster\_engine\_native\_audit\_fields\_included) | Specifies whether the database activity stream includes engine-native audit fields. This option only applies to an Oracle DB instance. By default, no engine-native audit fields are included | `bool` | `false` | no |
| <a name="input_cluster_global_cluster_identifier"></a> [cluster\_global\_cluster\_identifier](#input\_cluster\_global\_cluster\_identifier) | The global cluster identifier specified on `aws_rds_global_cluster` | `string` | `null` | no |
| <a name="input_cluster_iam_roles"></a> [cluster\_iam\_roles](#input\_cluster\_iam\_roles) | Map of IAM roles and supported feature names to associate with the cluster | `map(map(string))` | `{}` | no |
| <a name="input_cluster_instances"></a> [cluster\_instances](#input\_cluster\_instances) | Map of cluster instances and any specific/overriding attributes to be created | `any` | `{}` | no |
| <a name="input_cluster_instances_use_identifier_prefix"></a> [cluster\_instances\_use\_identifier\_prefix](#input\_cluster\_instances\_use\_identifier\_prefix) | Determines whether cluster instance identifiers are used as prefixes | `bool` | `false` | no |
| <a name="input_cluster_is_primary_cluster"></a> [cluster\_is\_primary\_cluster](#input\_cluster\_is\_primary\_cluster) | Determines whether cluster is primary cluster with writer instance (set to `false` for global cluster and replica clusters) | `bool` | `true` | no |
| <a name="input_cluster_members"></a> [cluster\_members](#input\_cluster\_members) | List of RDS Instances that are a part of this cluster | `list(string)` | `null` | no |
| <a name="input_cluster_parameters"></a> [cluster\_parameters](#input\_cluster\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | `[]` | no |
| <a name="input_cluster_predefined_metric_type"></a> [cluster\_predefined\_metric\_type](#input\_cluster\_predefined\_metric\_type) | The metric type to scale on. Valid values are `RDSReaderAverageCPUUtilization` and `RDSReaderAverageDatabaseConnections` | `string` | `"RDSReaderAverageCPUUtilization"` | no |
| <a name="input_cluster_replication_source_identifier"></a> [cluster\_replication\_source\_identifier](#input\_cluster\_replication\_source\_identifier) | ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica | `string` | `null` | no |
| <a name="input_cluster_scaling_configuration"></a> [cluster\_scaling\_configuration](#input\_cluster\_scaling\_configuration) | Map of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless` | `map(string)` | `{}` | no |
| <a name="input_cluster_serverlessv2_scaling_configuration"></a> [cluster\_serverlessv2\_scaling\_configuration](#input\_cluster\_serverlessv2\_scaling\_configuration) | Map of nested attributes with serverless v2 scaling properties. Only valid when `engine_mode` is set to `provisioned` | `map(string)` | `{}` | no |
| <a name="input_cluster_source_region"></a> [cluster\_source\_region](#input\_cluster\_source\_region) | The source region for an encrypted replica DB cluster | `string` | `null` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | A map of tags to add to only the cluster. Used for AWS Instance Scheduler tagging | `map(string)` | `{}` | no |
| <a name="input_cluster_timeouts"></a> [cluster\_timeouts](#input\_cluster\_timeouts) | Create, update, and delete timeout configurations for the cluster | `map(string)` | `{}` | no |
| <a name="input_cluster_use_name_prefix"></a> [cluster\_use\_name\_prefix](#input\_cluster\_use\_name\_prefix) | Whether to use `name` as a prefix for the cluster | `bool` | `false` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | On delete, copy all Instance tags to the final snapshot | `bool` | `false` | no |
| <a name="input_create_db_cluster_activity_stream"></a> [create\_db\_cluster\_activity\_stream](#input\_create\_db\_cluster\_activity\_stream) | Determines whether a cluster activity stream is created. | `bool` | `false` | no |
| <a name="input_create_db_instance"></a> [create\_db\_instance](#input\_create\_db\_instance) | Whether to create a database instance | `bool` | `true` | no |
| <a name="input_create_db_option_group"></a> [create\_db\_option\_group](#input\_create\_db\_option\_group) | Create a database option group | `bool` | `true` | no |
| <a name="input_create_db_parameter_group"></a> [create\_db\_parameter\_group](#input\_create\_db\_parameter\_group) | Whether to create a database parameter group | `bool` | `true` | no |
| <a name="input_custom_iam_instance_profile"></a> [custom\_iam\_instance\_profile](#input\_custom\_iam\_instance\_profile) | RDS custom iam instance profile | `string` | `null` | no |
| <a name="input_db_instance_tags"></a> [db\_instance\_tags](#input\_db\_instance\_tags) | Additional tags for the DB instance | `map(string)` | `{}` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The DB name to create. If omitted, no database is created initially | `string` | `null` | no |
| <a name="input_db_option_group_tags"></a> [db\_option\_group\_tags](#input\_db\_option\_group\_tags) | Additional tags for the DB option group | `map(string)` | `{}` | no |
| <a name="input_db_parameter_group_tags"></a> [db\_parameter\_group\_tags](#input\_db\_parameter\_group\_tags) | Additional tags for the  DB parameter group | `map(string)` | `{}` | no |
| <a name="input_db_subnet_group_description"></a> [db\_subnet\_group\_description](#input\_db\_subnet\_group\_description) | Description of the DB subnet group to create | `string` | `null` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC | `string` | `null` | no |
| <a name="input_db_subnet_group_tags"></a> [db\_subnet\_group\_tags](#input\_db\_subnet\_group\_tags) | Additional tags for the DB subnet group | `map(string)` | `{}` | no |
| <a name="input_db_subnet_group_use_name_prefix"></a> [db\_subnet\_group\_use\_name\_prefix](#input\_db\_subnet\_group\_use\_name\_prefix) | Determines whether to use `subnet_group_name` as is or create a unique name beginning with the `subnet_group_name` as the prefix | `bool` | `false` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specifies whether to remove automated backups immediately after the DB instance is deleted | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true | `bool` | `false` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The ID of the Directory Service Active Directory domain to create the instance in | `string` | `null` | no |
| <a name="input_domain_iam_role_name"></a> [domain\_iam\_role\_name](#input\_domain\_iam\_role\_name) | (Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service | `string` | `null` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values postgresql (PostgreSQL), upgrade (PostgreSQL) | `list(string)` | `[]` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use. If not specified the preffered version will be used. It is also possible to pass major version in this format "15". Note: that a specific version must be valid and this can be obtained from this documentation: https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html | `string` | `null` | no |
| <a name="input_enhanced_monitoring_create_role"></a> [enhanced\_monitoring\_create\_role](#input\_enhanced\_monitoring\_create\_role) | Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs | `bool` | `false` | no |
| <a name="input_enhanced_monitoring_iam_role_path"></a> [enhanced\_monitoring\_iam\_role\_path](#input\_enhanced\_monitoring\_iam\_role\_path) | Path for the monitoring role | `string` | `null` | no |
| <a name="input_enhanced_monitoring_interval"></a> [enhanced\_monitoring\_interval](#input\_enhanced\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60 | `number` | `0` | no |
| <a name="input_enhanced_monitoring_role_arn"></a> [enhanced\_monitoring\_role\_arn](#input\_enhanced\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring\_interval is non-zero | `string` | `null` | no |
| <a name="input_enhanced_monitoring_role_description"></a> [enhanced\_monitoring\_role\_description](#input\_enhanced\_monitoring\_role\_description) | Description of the monitoring IAM role | `string` | `null` | no |
| <a name="input_enhanced_monitoring_role_name"></a> [enhanced\_monitoring\_role\_name](#input\_enhanced\_monitoring\_role\_name) | Name of the IAM role which will be created when create\_monitoring\_role is enabled | `string` | `null` | no |
| <a name="input_enhanced_monitoring_role_permissions_boundary"></a> [enhanced\_monitoring\_role\_permissions\_boundary](#input\_enhanced\_monitoring\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the monitoring IAM role | `string` | `null` | no |
| <a name="input_enhanced_monitoring_role_use_name_prefix"></a> [enhanced\_monitoring\_role\_use\_name\_prefix](#input\_enhanced\_monitoring\_role\_use\_name\_prefix) | Determines whether to use `monitoring_role_name` as is or create a unique identifier beginning with `monitoring_role_name` as the specified prefix | `bool` | `false` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The name which is prefixed to the final snapshot on cluster destroy | `string` | `"final"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled | `bool` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the RDS instance | `string` | n/a | yes |
| <a name="input_idle_client_timeout"></a> [idle\_client\_timeout](#input\_idle\_client\_timeout) | Idle client timeout of the RDS proxy (keep connection alive) | `number` | `1800` | no |
| <a name="input_include_proxy"></a> [include\_proxy](#input\_include\_proxy) | Optionally include proxy to help manage database connections | `bool` | `false` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `""` | no |
| <a name="input_instance_parameters"></a> [instance\_parameters](#input\_instance\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | `[]` | no |
| <a name="input_instance_use_identifier_prefix"></a> [instance\_use\_identifier\_prefix](#input\_instance\_use\_identifier\_prefix) | Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix | `bool` | `false` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3` | `number` | `null` | no |
| <a name="input_is_db_cluster"></a> [is\_db\_cluster](#input\_is\_db\_cluster) | n/a | `bool` | `false` | no |
| <a name="input_is_serverless"></a> [is\_serverless](#input\_is\_serverless) | n/a | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used. Be sure to use the full ARN, not a key alias. | `string` | `null` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | The namespace used for IAM Role for ServiceAccount authentication from Kubernetes | `string` | `null` | no |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1 | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `"Sat:18:00-Sat:20:00"` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Set to true to allow RDS to manage the master user password in Secrets Manager | `bool` | `true` | no |
| <a name="input_master_user_secret_kms_key_id"></a> [master\_user\_secret\_kms\_key\_id](#input\_master\_user\_secret\_kms\_key\_id) | The key ARN, key ID, alias ARN or alias name for the KMS key to encrypt the master user password secret in Secrets Manager.<br>  If not specified, the default KMS key for your Amazon Web Services account is used. | `string` | `null` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Specifies the value for Storage Autoscaling | `number` | `0` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_nchar_character_set_name"></a> [nchar\_character\_set\_name](#input\_nchar\_character\_set\_name) | The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances. This can't be changed. | `string` | `null` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | The type of network stack to use | `string` | `null` | no |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | The OIDC provider used for IAM Role for ServiceAccount authentication from Kubernetes | `string` | `null` | no |
| <a name="input_option_group_description"></a> [option\_group\_description](#input\_option\_group\_description) | The description of the option group | `string` | `null` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | Name of the option group | `string` | `null` | no |
| <a name="input_option_group_timeouts"></a> [option\_group\_timeouts](#input\_option\_group\_timeouts) | Define maximum timeout for deletion of `aws_db_option_group` resource | `map(string)` | `{}` | no |
| <a name="input_option_group_use_name_prefix"></a> [option\_group\_use\_name\_prefix](#input\_option\_group\_use\_name\_prefix) | Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix | `bool` | `true` | no |
| <a name="input_options"></a> [options](#input\_options) | A list of Options to apply | `any` | `[]` | no |
| <a name="input_parameter_group_description"></a> [parameter\_group\_description](#input\_parameter\_group\_description) | Description of the DB parameter group to create | `string` | `null` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The family of the DB parameter group | `string` | `null` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the DB parameter group to associate or create | `string` | `null` | no |
| <a name="input_parameter_group_use_name_prefix"></a> [parameter\_group\_use\_name\_prefix](#input\_parameter\_group\_use\_name\_prefix) | Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix | `bool` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.<br>  The password provided will not be used if `manage_master_user_password` is set to true. | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | `false` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | The ARN for the KMS key to encrypt Performance Insights data | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31` | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `string` | `"5432"` | no |
| <a name="input_proxy_debug_logging"></a> [proxy\_debug\_logging](#input\_proxy\_debug\_logging) | Turn on debug logging for the proxy | `bool` | `false` | no |
| <a name="input_proxy_engine_family"></a> [proxy\_engine\_family](#input\_proxy\_engine\_family) | Engine family of the RDS proxy. Default: POSTGRESQL | `string` | `"POSTGRESQL"` | no |
| <a name="input_proxy_name"></a> [proxy\_name](#input\_proxy\_name) | Name of the RDS proxy. Will be auto-generated if not specified | `string` | `null` | no |
| <a name="input_proxy_require_tls"></a> [proxy\_require\_tls](#input\_proxy\_require\_tls) | Require tls on the RDS proxy. Default: true | `bool` | `true` | no |
| <a name="input_proxy_security_group_rules"></a> [proxy\_security\_group\_rules](#input\_proxy\_security\_group\_rules) | n/a | <pre>object({<br>    ingress_rules     = list(any)<br>    ingress_with_self = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "ingress_rules": []<br>}</pre> | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| <a name="input_rds_proxy_iam_auth"></a> [rds\_proxy\_iam\_auth](#input\_rds\_proxy\_iam\_auth) | n/a | `string` | `"DISABLED"` | no |
| <a name="input_rds_security_group_rules"></a> [rds\_security\_group\_rules](#input\_rds\_security\_group\_rules) | n/a | <pre>object({<br>    ingress_rules     = list(any)<br>    ingress_with_self = optional(list(any), [])<br>  })</pre> | n/a | yes |
| <a name="input_replica_mode"></a> [replica\_mode](#input\_replica\_mode) | Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified | `string` | `null` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate | `string` | `null` | no |
| <a name="input_restore_to_point_in_time"></a> [restore\_to\_point\_in\_time](#input\_restore\_to\_point\_in\_time) | Restore to a point in time (MySQL is NOT supported) | `map(string)` | `null` | no |
| <a name="input_s3_import"></a> [s3\_import](#input\_s3\_import) | Restore from a Percona Xtrabackup in S3 (only MySQL is supported) | `map(string)` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05 | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_storage_throughput"></a> [storage\_throughput](#input\_storage\_throughput) | Storage throughput value for the DB instance. See `notes` for limitations regarding this variable for `gp3` | `number` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter | `string` | `"gp2"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times | `map(string)` | `{}` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information | `string` | `null` | no |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_instance_profile_for_ec2"></a> [iam\_instance\_profile\_for\_ec2](#output\_iam\_instance\_profile\_for\_ec2) | The name of the EC2 instance profile that is using the IAM Role that give AWS services access to the RDS instance and Secrets Manager |
| <a name="output_iam_role_arn_for_aws_services"></a> [iam\_role\_arn\_for\_aws\_services](#output\_iam\_role\_arn\_for\_aws\_services) | The ARN of the IAM Role that give AWS services access to the RDS instance and Secrets Manager |
| <a name="output_instance_engine_info"></a> [instance\_engine\_info](#output\_instance\_engine\_info) | The engine info for the selected engine of the RDS instance |
| <a name="output_kubernetes_serviceaccount"></a> [kubernetes\_serviceaccount](#output\_kubernetes\_serviceaccount) | If you create this Kubernetes ServiceAccount, you will get access to the RDS through IRSA |
<!-- END_TF_DOCS -->
