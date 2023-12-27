# output "db_instance_master_user_secret_arn" {
#   description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
#   value       = module.db[0].db_instance_master_user_secret_arn
# }

# output "db_cluster_master_user_secret_arn" {
#   description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
#   value       = module.cluster[0].cluster_master_user_secret_arn
# }

output "kubernetes_serviceaccount" {
  description = "If you create this Kubernetes ServiceAccount, you will get access to the RDS through IRSA"
  value = try(<<EOT

apiVersion: v1
kind: ServiceAccount
metadata:
    name: ${module.db_instance[0].db_instance_identifier}
    namespace: ${local.kubernetes_namespace}
    annotations:
        eks.amazonaws.com/role-arn: "${module.db_instance[0].iam_role_for_kubernetes_serviceaccounts.arn}"
        eks.amazonaws.com/sts-regional-endpoints: "true"
EOT
  , null)
}

output "iam_role_arn_for_aws_services" {
  description = "The ARN of the IAM Role that give AWS services access to the RDS instance and Secrets Manager"
  value       = try(module.db_instance[0].iam_role_for_aws_services.arn, null)
}

output "iam_instance_profile_for_ec2" {
  description = "The name of the EC2 instance profile that is using the IAM Role that give AWS services access to the RDS instance and Secrets Manager"
  value       = try(module.db_instance[0].iam_instance_profile_for_ec2, null)
}

output "instance_engine_info" {
  description = "The engine info for the selected engine of the RDS instance"
  value       = jsonencode(data.aws_rds_engine_version.engine_info)
}
