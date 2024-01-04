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
    "dfds.automation.tool" = "Terraform"
  }
}

module "rds_instance_test" {
  source             = "../../"
  create_db_instance = true
  identifier         = local.name


  username = "instance_user"

  apply_immediately                      = true
  is_publicly_accessible                 = true
  subnet_ids                             = concat(module.vpc.public_subnets)
  enabled_cloudwatch_logs_exports        = ["upgrade", "postgresql"]
  cloudwatch_log_group_retention_in_days = 1
  is_proxy_included                      = false
  proxy_debug_logging_is_enabled         = true

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
  environment                  = "dev"
  service_availability         = "low"
  resource_owner_contact_email = "example@dfds.com"
  cost_centre                  = "buarch-d"
  data_classification          = "public"
  enable_default_backup        = true
  optional_tags                = local.tags
  is_kubernetes_app_enabled    = true
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

  tags = local.tags
}
