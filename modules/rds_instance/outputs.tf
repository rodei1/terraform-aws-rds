output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = try(aws_db_instance.this.address, null)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this.arn, null)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = try(aws_db_instance.this.availability_zone, null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_db_instance.this.endpoint, null)
}

output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = try(aws_db_instance.this.listener_endpoint, null)
}

output "db_instance_engine" {
  description = "The database engine"
  value       = try(aws_db_instance.this.engine, null)
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = try(aws_db_instance.this.engine_version_actual, null)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = try(aws_db_instance.this.hosted_zone_id, null)
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = try(aws_db_instance.this.identifier, null)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.this.resource_id, null)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(aws_db_instance.this.status, null)
}

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.this.db_name, null)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.this.username, null)
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.this.port, null)
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = try(aws_db_instance.this.ca_cert_identifier, null)
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = try(aws_db_instance.this.domain, null)
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = try(aws_db_instance.this.domain_iam_role_name, null)
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}

output "iam_role_for_kubernetes_serviceaccounts" {
  description = "The ARN of the IAM Role that gives Kubernetes service accounts access to AWS"
  value       = try(aws_iam_role.access_from_kubernetes[0], null)
}

output "iam_role_for_aws_services" {
  description = "The ARN of the IAM Role that give AWS services access to the RDS instance and Secrets Manager"
  value       = try(aws_iam_role.access_from_aws, null)
}

output "iam_instance_profile_for_ec2" {
  description = "The name of the EC2 instance profile to use to access RDS"
  value       = try(aws_iam_instance_profile.ec2.name, null)
}
