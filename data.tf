data "aws_rds_engine_version" "default" {
  engine       = local.engine
  default_only = true
}
