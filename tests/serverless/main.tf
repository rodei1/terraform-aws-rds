provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name   = "postgresql-serverless"
  region = "eu-central-1"

  vpc_cidr = "10.20.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-rds"
  }
}


module "rds_serverless_test" {
  source     = "../../"
  identifier = local.name

  is_serverless             = true
  cluster_db_instance_count = 0
  username                  = "cluster_user"
  vpc_security_group_ids    = [module.security_group.security_group_id]
  ca_cert_identifier        = "rds-ca-ecc384-g1"
  apply_immediately         = true
  tags                      = local.tags


  publicly_accessible = true

  subnet_ids        = concat(module.vpc.public_subnets)
  allocated_storage = 100

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  ########################################################################
  # TODO: Fix this is not working with serverless atm because of missing IAM role.
  # See how it is implemented in the instance module
  include_proxy = false
  ########################################################################

  engine_version               = "13"
  enhanced_monitoring_interval = 60

  rds_security_group_rules = {
    ingress_rules = [
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

module "security_group" { # update with another rule for public access
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "PostgreSQL access from internet"
    },
  ]

  tags = local.tags
}
