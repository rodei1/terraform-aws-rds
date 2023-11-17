################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = try(aws_rds_cluster.this.arn, null)
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = try(aws_rds_cluster.this.id, null)
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = try(aws_rds_cluster.this.cluster_resource_id, null)
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = try(aws_rds_cluster.this.cluster_members, null)
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = try(aws_rds_cluster.this.endpoint, null)
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = try(aws_rds_cluster.this.reader_endpoint, null)
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = try(aws_rds_cluster.this.engine_version_actual, null)
}

# database_name is not set on `aws_rds_cluster` resource if it was not specified, so can't be used in output
output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = var.database_name
}

output "cluster_port" {
  description = "The database port"
  value       = try(aws_rds_cluster.this.port, null)
}

output "cluster_master_password" {
  description = "The database master password"
  value       = try(aws_rds_cluster.this.master_password, null)
  sensitive   = true
}

output "cluster_master_username" {
  description = "The database master username"
  value       = try(aws_rds_cluster.this.master_username, null)
  sensitive   = true
}

output "cluster_master_user_secret" {
  description = "The generated database master user secret when `manage_master_user_password` is set to `true`"
  value       = try(aws_rds_cluster.this.master_user_secret, null)
}

output "cluster_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = try(aws_rds_cluster.this.master_user_secret[0].secret_arn, null)
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = try(aws_rds_cluster.this.hosted_zone_id, null)
}

################################################################################
# Cluster Instance(s)
################################################################################

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = aws_rds_cluster_instance.this
}

################################################################################
# Cluster Endpoint(s)
################################################################################

output "additional_cluster_endpoints" {
  description = "A map of additional cluster endpoints and their attributes"
  value       = aws_rds_cluster_endpoint.this
}

################################################################################
# Cluster IAM Roles
################################################################################

output "cluster_role_associations" {
  description = "A map of IAM roles associated with the cluster and their attributes"
  value       = aws_rds_cluster_role_association.this
}

################################################################################
# Cluster Activity Stream
################################################################################

output "db_cluster_activity_stream_kinesis_stream_name" {
  description = "The name of the Amazon Kinesis data stream to be used for the database activity stream"
  value       = try(aws_rds_cluster_activity_stream.this[0].kinesis_stream_name, null)
}