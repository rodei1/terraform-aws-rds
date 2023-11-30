resource "aws_cloudwatch_log_group" "this" {
  for_each = toset([for log in var.enabled_cw_logs_exports : log])

  name              = "/aws/rds/instance/${var.db_identifier}/${each.value}" # it is not possible to use the identifier_prefix here since it is not known at plan time and we can't have cyclic reference to the db instance resource
  retention_in_days = var.cw_log_group_retention_in_days
  kms_key_id        = var.cw_log_group_kms_key_id
  skip_destroy      = var.cw_log_group_skip_destroy_on_deletion
  tags              = var.tags
}
