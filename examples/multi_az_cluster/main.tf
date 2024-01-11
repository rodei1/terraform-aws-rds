provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "multiaz-postgresql-cluster"
  region = "eu-central-1"

  tags = {
    Name = local.name
  }
}

module "rds_cluster_test" {
  source                       = "../../"
  is_cluster                   = true
  environment                  = "dev"
  identifier                   = local.name
  is_kubernetes_app_enabled    = false
  is_proxy_included            = false
  service_availability         = "low"
  username                     = "multiaz_cluster_user"
  vpc_id                       = module.vpc.vpc_id
  is_publicly_accessible       = true
  subnet_ids                   = concat(module.vpc.public_subnets)
  resource_owner_contact_email = "noreply@example.com"
  cost_centre                  = "ti-arch"
  data_classification          = "public"
  optional_tags                = local.tags
  instance_class               = "db.m5d.large"
  storage_type                 = "io1"
  allocated_storage            = 100
  deletion_protection          = false

  # enabled_cloudwatch_logs_exports        = ["upgrade", "postgresql"]
  # cloudwatch_log_group_retention_in_days = 1
}

################################################################################
# Supporting Resources - Example VPC
################################################################################

module "vpc" {
  source = "../shared/"
  name   = local.name
  cidr   = "10.22.0.0/16"
  tags   = local.tags
}
