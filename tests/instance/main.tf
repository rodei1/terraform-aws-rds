provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name   = "postgresql-instance"
  region = "eu-central-1"

  vpc_cidr = "10.20.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}


module "rds_instance_test" {
  source     = "../../"
  identifier = local.name

  instance_class = "db.t3.micro"
  multi_az       = true
  username       = "instance_user"
  # vpc_security_group_ids = [module.security_group.security_group_id]
  ca_cert_identifier = "rds-ca-ecc384-g1"
  apply_immediately  = true
  tags               = local.tags


  publicly_accessible = true

  subnet_ids        = concat(module.vpc.public_subnets)
  allocated_storage = 5

  enabled_cloudwatch_logs_exports        = ["upgrade", "postgresql"]
  cloudwatch_log_group_retention_in_days = 1

  rds_proxy_security_group_ids = [aws_security_group.rds_proxy_sg.id]

  include_proxy       = true
  proxy_debug_logging = true

  enhanced_monitoring_interval = 0

  allow_major_version_upgrade = true # default ?
  major_engine_version        = 16

  performance_insights_enabled = true

  # Group variables into maps
  vpc_id = module.vpc.vpc_id
  rds_security_group_rules = {
    ingress_rules = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access from within VPC"
        cidr_blocks = module.vpc.vpc_cidr_block
      },
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access from internet"
        cidr_blocks = "0.0.0.0/0"
      },
    ]
  }

}



################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  # database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]

  # create_database_subnet_group = true

  tags = local.tags
}


resource "aws_security_group" "rds_proxy_sg" { # TODO: add conditional to only create when proxy is enabled

  name        = "rds-proxy-${local.name}"
  description = "A security group for ${local.name} database proxy"
  vpc_id      = module.vpc.vpc_id

  tags = local.tags

  # Proxy requires self referencing inbound rule
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  # Allow outbound all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
