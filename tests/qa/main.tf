provider "aws" {
  region = local.region
}

locals {
  name   = "qa"
  region = "eu-central-1"

  tags = {
    Name                                 = local.name
    Repository                           = "https://github.com/dfds/aws-modules-rds"
    "dfds.automation.tool"               = "Terraform"
    "dfds.automation.initiator.location" = "https://github.com/dfds/aws-modules-rds/"
    "dfds.automation.initiator.pipeline" = "https://github.com/dfds/aws-modules-rds/actions/workflows/qa.yml"
    "dfds.test.scope"                    = "qa"
  }

}

module "rds_instance_test" { # TODO: change to only use defaults and required variables
  source                                 = "../../"
  identifier                             = local.name
  environment                            = "test"
  instance_class                         = "db.t3.micro"
  db_name                                = "qadb"
  instance_is_multi_az                   = true
  username                               = "qa_user"
  manage_master_user_password            = true
  iam_database_authentication_enabled    = true
  ca_cert_identifier                     = "rds-ca-ecc384-g1"
  apply_immediately                      = true
  is_publicly_accessible                 = true
  subnet_ids                             = ["subnet-04d5d42ac21fd8e8f", "subnet-0e50a82dec5fc0272", "subnet-0a49d384ff2e8a580"]
  enabled_cloudwatch_logs_exports        = ["upgrade", "postgresql"]
  cloudwatch_log_group_retention_in_days = 1
  is_proxy_included                      = true
  proxy_debug_logging_is_enabled         = true
  enhanced_monitoring_interval           = 0
  allow_major_version_upgrade            = true
  engine_version                         = "16.1"
  performance_insights_enabled           = true
  vpc_id                                 = "vpc-04a384af7d3657687"
  deletion_protection                    = false
  service_availability                   = "low"
  resource_owner_contact_email           = "example@dfds.com"
  cost_centre                            = "ti-arch"
  data_classification                    = "public"
  enable_default_backup                  = false
  optional_tags                          = local.tags

  proxy_security_group_rules = {
    ingress_rules = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access over VPC peering"
        cidr_blocks = "10.0.0.0/16"
      },
    ]
  }

  rds_security_group_rules = {
    ingress_rules = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access from within VPC"
        cidr_blocks = "10.100.56.0/22"
      },
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access over VPC peering"
        cidr_blocks = "10.0.0.0/16"
      },
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access from public IPs"
        cidr_blocks = "0.0.0.0/0"
      },
    ]
  }
  is_kubernetes_app_enabled = true
}
