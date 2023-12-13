data "aws_rds_engine_version" "engine_info" { # preferred vesion.
  engine       = local.engine
  version      = var.engine_version
  default_only = !local.is_major_engine_version || var.engine_version == null
}
