data "aws_rds_engine_version" "default" {
  engine       = local.engine
  version      = var.engine_version
  default_only = var.engine_version != null ? false : true
}
