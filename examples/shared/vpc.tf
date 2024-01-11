
data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

variable "name" {
  type = string
}
variable "cidr" {
  type = string
}
variable "tags" {
  type = map(string)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 3)]

  tags = var.tags
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
