# terraform-aws-rds

Terraform module for AWS RDS instances

# Documentation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 1.6.0 |
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
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_rds_engine_version.engine_info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_ssm_parameter.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_peering_connection.kubernetes_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |
| [aws_vpc_peering_connections.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connections) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_backup_retention"></a> [additional\_backup\_retention](#input\_additional\_backup\_retention) | Specify additional backup retention.<br>    Valid Values: 30days, 60days, 180days, 1year, 10year<br>    Notes: This set the dfds.backup\_retention tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | `null` | no |
| <a name="input_additional_rds_security_group_rules"></a> [additional\_rds\_security\_group\_rules](#input\_additional\_rds\_security\_group\_rules) | Specify additional security group rules for the RDS instance.<br>    Valid Values: .<br>    Notes: Use only for special cases. | <pre>object({<br>    ingress_rules     = list(any)<br>    ingress_with_self = optional(list(any), [])<br>    egress_rules      = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "egress_rules": [],<br>  "ingress_rules": [],<br>  "ingress_with_self": []<br>}</pre> | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Specify the allocated storage in gigabytes.<br>    Valid Values: .<br>    Notes: . | `number` | `null` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Specify whether or not that major version upgrades are allowed.<br>    Valid Values: .<br>    Notes: Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible" | `bool` | `true` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifiy whether any database modifications are applied immediately, or during the next maintenance window<br>    Valid Values: .<br>    Notes: apply\_immediately can result in a brief downtime as the server reboots. See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html) for more information. | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specify whether or not that minor engine upgrades can be applied automatically to the DB instance".<br>    Valid Values: .<br>    Notes: Minor engine upgrades will be applied automatically to the DB instance during the maintenance window. | `bool` | `true` | no |
| <a name="input_automation_initiator_location"></a> [automation\_initiator\_location](#input\_automation\_initiator\_location) | Specify the URL to the repo of automation script.<br>    Valid Values: URL to repo. Example: `"https://github.com/dfds/terraform-aws-rds"`<br>    Notes: This set the dfds.automation.initiator.location tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Specify the Availability Zone for the RDS instance..<br>    Valid Values:<br>    Notes: Only available for DB instances that do not have multi-AZ enabled. | `string` | `null` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | Specify the identifier of the CA certificate for the DB instance.<br>    Valid Values: .<br>    Notes: If this variable is omitted, the latest CA certificate will be used. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | Specify the ARN of the KMS Key to use when encrypting log data.<br>    Valid Values: .<br>    Notes: . | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specify the retention period in days for the CloudWatch logs.<br>    Valid Values: Number of days<br>    Notes: . | `number` | `1` | no |
| <a name="input_cloudwatch_log_group_skip_destroy_on_deletion"></a> [cloudwatch\_log\_group\_skip\_destroy\_on\_deletion](#input\_cloudwatch\_log\_group\_skip\_destroy\_on\_deletion) | Specify whether or not to skip the deletion of the CloudWatch log group on deletion.<br>    Valid Values: .<br>    Notes: . | `bool` | `false` | no |
| <a name="input_cluster_parameters"></a> [cluster\_parameters](#input\_cluster\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | `[]` | no |
| <a name="input_cluster_use_name_prefix"></a> [cluster\_use\_name\_prefix](#input\_cluster\_use\_name\_prefix) | Whether to use `name` as a prefix for the cluster | `bool` | `false` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Specifies whether or not to copy all Instance tags to the final snapshot on deletion.<br>    Valid Values: .<br>    Notes: Default value is set to true. Snapshots will be created by the AWS backup job assuming that this resource is properly tagged, see [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started) for more info. | `bool` | `false` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Provide a cost centre for the resource.<br>    Valid Values: .<br>    Notes: This set the dfds.cost\_centre tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | n/a | yes |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Specify data classification.<br>    Valid Values: public, private, confidential, restricted<br>    Notes: This set the dfds.data.classification tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Specifies The DB name to create.<br>    Valid Values: .<br>    Notes: If omitted, no database is created initially. | `string` | `null` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specify whether or not whether to remove automated backups immediately after the DB instance is deleted.<br>    Valid Values: .<br>    Notes: . | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Specify whether or not to prevent the DB instance from being deleted.<br>    Valid Values: .<br>    Notes: The database can't be deleted when this value is set to true. | `bool` | `true` | no |
| <a name="input_enable_default_backup"></a> [enable\_default\_backup](#input\_enable\_default\_backup) | Specify whether or not to enable default backup.<br>    Valid Values: .<br>    Notes:<br>    - This set the dfds.backup tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy).<br>    - If omitted, the default value is set to true for production and false for non-production environments. | `bool` | `null` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Specify the list of log types to enable for exporting to CloudWatch logs.<br>    Valid Values: postgresql (PostgreSQL), upgrade (PostgreSQL)<br>    Notes: If omitted, no logs will be exported. | `list(string)` | `[]` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specify engine version to use.<br>    Valid Values: Specific version number, for example, "15.3" or major version number, for example, "15".<br>    Notes:<br>    - If this is omitted, the preffered version will be used.<br>    - If major version is specified, the preffered version will be used.<br>    - When using a specific version. The version must be valid. A valid  version can be obtained from this [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/PostgreSQLReleaseNotes/postgresql-release-calendar.html) | `string` | `null` | no |
| <a name="input_enhanced_monitoring_interval"></a> [enhanced\_monitoring\_interval](#input\_enhanced\_monitoring\_interval) | Specify the interval between points when Enhanced Monitoring metrics are collected for the DB instance.<br>    Valid Values: 0, 1, 5, 10, 15, 30, 60 (in seconds)<br>    Notes: Specify 0 to disable collecting Enhanced Monitoring metrics. | `number` | `0` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Specify the staging environment.<br>    Valid Values: "dev", "test", "staging", "uat", "training", "prod".<br>    Notes: The value will set configuration defaults according to DFDS policies. | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | Specifies the name which is prefixed to the final snapshot on cluster destroy.<br>    Valid Values: .<br>    Notes: . | `string` | `"final"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Set this to true to enable authentication using IAM.<br>    Valid Values: .<br>    Notes: This requires creating mappings between IAM users/roles and database accounts in the RDS instance for this to work properly. | `bool` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Specify the name of the RDS instance to create.<br>    Valid Values: .<br>    Notes: . | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Specify instance type of the RDS instance.<br>    Valid Values:<br>      "db.t3.micro",<br>      "db.t3.small",<br>      "db.t3.medium",<br>      "db.t3.large",<br>      "db.t3.xlarge",<br>      "db.t3.2xlarge",<br>      "db.r6g.xlarge",<br>      "db.m6g.large",<br>      "db.m6g.xlarge",<br>      "db.t2.micro",<br>      "db.t2.small",<br>      "db.t2.medium",<br>      "db.m4.large",<br>      "db.m5d.large",<br>      "db.m6i.large",<br>      "db.m5.xlarge",<br>      "db.t4g.micro",<br>      "db.t4g.small",<br>      "db.t4g.large",<br>      "db.t4g.xlarge"<br>    Notes: If omitted, the instance type will be set to db.t3.micro. | `string` | `null` | no |
| <a name="input_instance_is_multi_az"></a> [instance\_is\_multi\_az](#input\_instance\_is\_multi\_az) | Specify if the RDS instance is multi-AZ.<br>    Valid Values: .<br>    Notes:<br>    - This creates a primary DB instance and a standby DB instance in a different AZ for high availability and data redundancy.<br>    - Standby DB instance doesn't support connections for read workloads.<br>    - If this variable is omitted:<br>      - This value is set to true by default for production environments.<br>      - This value is set to false by default for non-production environments. | `bool` | `null` | no |
| <a name="input_instance_parameters"></a> [instance\_parameters](#input\_instance\_parameters) | Specify a list of DB parameters (map) to modify.<br>    Valid Values: Example:<br>      instance\_parameters = [{<br>          name         = "rds.force\_ssl"<br>          value        = 1<br>          apply\_method = "pending-reboot",<br>          ... # Other parameters<br>        }]<br>    Notes: See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters) for more information. | `list(map(string))` | `[]` | no |
| <a name="input_instance_terraform_timeouts"></a> [instance\_terraform\_timeouts](#input\_instance\_terraform\_timeouts) | Specify Terraform resource management timeouts.<br>    Valid Values: .<br>    Notes: Applies to `aws_db_instance` in particular to permit resource management times. See [documentation](https://www.terraform.io/docs/configuration/resources.html#operation-timeouts) for more information. | `map(string)` | `{}` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | Specify The amount of provisioned IOPS.<br>    Valid Values: .<br>    Notes: Setting this implies a storage\_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`" | `number` | `null` | no |
| <a name="input_is_cluster"></a> [is\_cluster](#input\_is\_cluster) | [Experiemental Feature] Specify whether or not to deploy the instance as multi-az database cluster.<br>    Valid Values: .<br>    Notes:<br>    - This feature is currently in beta and is subject to change.<br>    - It creates a DB cluster with a primary DB instance and two readable standby DB instances,<br>    - Each DB instance in a different Availability Zone (AZ).<br>    - Provides high availability, data redundancy and increases capacity to serve read workloads<br>    - Proxy is not supported for cluster instances.<br>    - For smaller workloads we recommend considering using a single instance instead of a cluster. | `bool` | `false` | no |
| <a name="input_is_kubernetes_app_enabled"></a> [is\_kubernetes\_app\_enabled](#input\_is\_kubernetes\_app\_enabled) | Specify whether or not to enable access from Kubernetes pods.<br>    Valid Values: .<br>    Notes: Enabling this will create the following resources:<br>      - IAM role for service account (IRSA)<br>      - IAM policy for service account (IRSA)<br>      - Peering connection from EKS Cluster requires a VPC peering deployed in the AWS account. | `bool` | `false` | no |
| <a name="input_is_proxy_included"></a> [is\_proxy\_included](#input\_is\_proxy\_included) | Specify whether or not to include proxy.<br>    Valid Values: .<br>    Notes: Proxy helps managing database connections. See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-planning.html) for more information. | `bool` | `false` | no |
| <a name="input_is_publicly_accessible"></a> [is\_publicly\_accessible](#input\_is\_publicly\_accessible) | Specify whether or not this instance is publicly accessible.<br>    Valid Values: .<br>    Notes:<br>    - Setting this to true will do the followings:<br>      - Assign a public IP address and the host name of the DB instance will resolve to the public IP address.<br>      - Access from within the VPC can be achived by using the private IP address of the assigned Network Interface.<br>      - Create a security group rule to allow inbound traffic from the specified CIDR blocks.<br>        - It is required to set `public_access_ip_whitelist` to allow access from specific IP addresses. | `bool` | `false` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specify the window to perform maintenance in.<br>    Valid Values: Syntax: `ddd:hh24:mi-ddd:hh24:mi`. Eg: `"Mon:00:00-Mon:03:00"`.<br>    Notes: Default value is set to `"Sat:18:00-Sat:20:00"`. This is adjusted in accordance with AWS Backup schedule, see info [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started). | `string` | `"Sat:18:00-Sat:20:00"` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Set to true to allow RDS to manage the master user password in Secrets Manager.<br>    Valid Values: .<br>    Notes:<br>    - Default value is set to true. It is recommended to use this feature.<br>    - If set to true, the `password` variable will be ignored. | `bool` | `true` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Set the value to enable Storage Autoscaling and to set the max allocated storage.<br>    Valid Values: .<br>    Notes:<br>    - If this variable is omitted:<br>      - This value is set to 50 by default for production environments.<br>      - This value is set to 0 by default for non-production environments. | `number` | `null` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | Specify the network type of the DB instance.<br>    Valid Values: IPV4, DUAL<br>    Notes: . | `string` | `null` | no |
| <a name="input_optional_data_specific_tags"></a> [optional\_data\_specific\_tags](#input\_optional\_data\_specific\_tags) | Provide list of optional dfds.data.* to be applied on data specific resources.<br>    Valid Values: .<br>    Notes:<br>    - Use this only for optional data tags. Required tags are supplied through dedicated variables.<br>    - This variable will apply tags only on the relevant data resources.<br>    - See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `map(string)` | `{}` | no |
| <a name="input_optional_tags"></a> [optional\_tags](#input\_optional\_tags) | Provide list of optional dfds.* tags to be applied on all resources.<br>    Valid Values: .<br>    Notes:<br>    - Use this only for optional tags. Required tags are supplied through dedicated variables.<br>    - See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `map(string)` | `{}` | no |
| <a name="input_password"></a> [password](#input\_password) | Specify password for the master DB user.<br>    Valid Values: .<br>    Notes:<br>    - This password may show up in logs, and it will be stored in the state file.<br>    - If `manage_master_user_password` is set to true, this value will be ignored. | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specify whether or not to enable Performance Insights.<br>    Valid Values: .<br>    Notes:<br>    - If this variable is omitted:<br>      - This value is set to true by default for production environments. Default retention period is set to 7 days.<br>      - This value is set to false by default for non-production environments. | `bool` | `null` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | Specify the ARN for the KMS key to encrypt Performance Insights data.<br>    Valid Values: .<br>    Notes:<br>      - When specifying performance\_insights\_kms\_key\_id, performance\_insights\_enabled needs to be set to true.<br>      - Once KMS key is set, it can never be changed | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Specify the retention period for Performance Insights.<br>    Valid Values: `7`, `731` (2 years) or a multiple of `31`<br>    Notes: Set the value Default value when `performance_insights_enabled` is set to true. | `number` | `null` | no |
| <a name="input_pipeline_location"></a> [pipeline\_location](#input\_pipeline\_location) | Specify a valid URL path to the pipeline file used for automation script.<br>    Valid Values: URL to repo. Example: `"https://github.com/dfds/terraform-aws-rds/actions/workflows/qa.yml"`<br>    Notes: This set the dfds.automation.initiator.pipeline tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Specify the port number on which the DB accepts connections.<br>    Valid Values: .<br>    Notes: Default value is set to 5432. | `number` | `5432` | no |
| <a name="input_proxy_additional_security_group_rules"></a> [proxy\_additional\_security\_group\_rules](#input\_proxy\_additional\_security\_group\_rules) | Specify additional security group rules for the RDS proxy.<br>    Valid Values: .<br>    Notes:<br>    - Public access is not supported on RDS Proxy. See [documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html#rds-proxy.limitations) for more information.<br>    - Only ingress(inbound) rules are supported.<br>    - Ingress rules are set to "Allow outbound traffic to PostgreSQL instance"<br>    – Ingress rules are set to "Allow inbound traffic from same security group on specified database port" | <pre>object({<br>    ingress_rules     = list(any)<br>    ingress_with_self = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "ingress_rules": []<br>}</pre> | no |
| <a name="input_proxy_debug_logging_is_enabled"></a> [proxy\_debug\_logging\_is\_enabled](#input\_proxy\_debug\_logging\_is\_enabled) | Turn on debug logging for the proxy.<br>    Valid Values: .<br>    Notes: . | `bool` | `false` | no |
| <a name="input_proxy_engine_family"></a> [proxy\_engine\_family](#input\_proxy\_engine\_family) | Specify engine family of the RDS proxy.<br>    Valid Values: POSTGRESQL<br>    Notes: . | `string` | `"POSTGRESQL"` | no |
| <a name="input_proxy_iam_auth"></a> [proxy\_iam\_auth](#input\_proxy\_iam\_auth) | Specify whether or not to use IAM authentication for the proxy.<br>    Valid Values: DISABLED, REQUIRED<br>    Notes: . | `string` | `"DISABLED"` | no |
| <a name="input_proxy_idle_client_timeout"></a> [proxy\_idle\_client\_timeout](#input\_proxy\_idle\_client\_timeout) | Specify idle client timeout of the RDS proxy (keep connection alive).<br>    Valid Values: .<br>    Notes: . | `number` | `1800` | no |
| <a name="input_proxy_require_tls"></a> [proxy\_require\_tls](#input\_proxy\_require\_tls) | Specify whether or not to require TLS for the proxy.<br>    Valid Values: .<br>    Notes: Default value is set to true. | `bool` | `true` | no |
| <a name="input_public_access_ip_whitelist"></a> [public\_access\_ip\_whitelist](#input\_public\_access\_ip\_whitelist) | Provide a list of IP addresses to whitelist for public access<br>    Valid Values: List of CIDR blocks. For example ["x.x.x.x/32", "y.y.y.y/32"]<br>    Notes:<br>    - In case of publicly accessible RDS, this list will be used to whitelist the IP addresses.<br>    - It is best practice to specify the IP addresses that require access to the RDS instance.<br>    - Setting this value to ["0.0.0.0/0"] will mean that the RDS instance will be open to the world! Following are examples where it can be necessary:<br>      - Access is done from workloads with randomly assigned public IP adresses.<br>      - A VPC peering is not configured. | `list(string)` | `[]` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Inidicate that this resource is a Replicate database, and to use this value as the source database.<br>    Valid Values: The identifier of another Amazon RDS Database to replicate in the same region.<br>    Notes: In case of cross-region replication, specify the ARN of the source DB instance. | `string` | `null` | no |
| <a name="input_resource_owner_contact_email"></a> [resource\_owner\_contact\_email](#input\_resource\_owner\_contact\_email) | Provide an email address for the resource owner (e.g. team or individual).<br>    Valid Values: .<br>    Notes: This set the dfds.owner tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | `null` | no |
| <a name="input_service_availability"></a> [service\_availability](#input\_service\_availability) | Specify service availability.<br>    Valid Values: low, medium, high<br>    Notes: This set the dfds.service.availability tag. See recommendations [here](https://wiki.dfds.cloud/en/playbooks/standards/tagging_policy). | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Setting this will determine whether a final DB snapshot is created before the DB instance is deleted.<br>    Valid Values: Specific version number, for example, "15.3" or major version number, for example, "15".<br>    Notes:<br>    - If true is specified, no DB Snapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted.<br>    - Default value is set to true. Snapshots will be created by the AWS backup job assuming that this resource is properly tagged, see [here](https://wiki.dfds.cloud/en/playbooks/aws-backup/aws-backup-getting-started) for more info. | `bool` | `true` | no |
| <a name="input_source_snapshot_identifier"></a> [source\_snapshot\_identifier](#input\_source\_snapshot\_identifier) | Provide the ID of the snapshot to create this instance from.<br>    Valid Values: This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05"<br>    Notes: Setting this will cause the instance to restore from the specified snapshot. | `string` | `null` | no |
| <a name="input_storage_throughput"></a> [storage\_throughput](#input\_storage\_throughput) | Speficy storage throughput value for the DB instance.<br>    Valid Values: .<br>    Notes: See `notes` for limitations regarding this variable for `gp3`. | `number` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Specify the storage type.<br>    Valid Values: One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD).<br>    Notes: Default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter. | `string` | `"gp3"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Provide a list of VPC subnet IDs.<br>    Valid Values: .<br>    Notes: IDs of the subnets must be in the same VPC as the RDS instance. Example: ["subnet-aaaaaaaaaaa", "subnet-bbbbbbbbbbb", "subnet-cccccccccc"] | `list(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Specify Username for the master DB user.<br>    Valid Values: .<br>    Notes: . | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specify the VPC ID.<br>    Valid Values: .<br>    Notes: . | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_instance_profile_for_ec2"></a> [iam\_instance\_profile\_for\_ec2](#output\_iam\_instance\_profile\_for\_ec2) | The name of the EC2 instance profile that is using the IAM Role that give AWS services access to the RDS instance and Secrets Manager |
| <a name="output_iam_role_arn_for_aws_services"></a> [iam\_role\_arn\_for\_aws\_services](#output\_iam\_role\_arn\_for\_aws\_services) | The ARN of the IAM Role that give AWS services access to the RDS instance and Secrets Manager |
| <a name="output_kubernetes_serviceaccount"></a> [kubernetes\_serviceaccount](#output\_kubernetes\_serviceaccount) | If you create this Kubernetes ServiceAccount, you will get access to the RDS through IRSA |
| <a name="output_peering"></a> [peering](#output\_peering) | n/a |
<!-- END_TF_DOCS -->
