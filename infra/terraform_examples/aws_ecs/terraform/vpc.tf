data "aws_availability_zones" "available" {}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_name = "${var.project_name}-${var.environment}"
  cidr     = "10.1.0.0/16"
}

data "aws_vpc" "selected" {
  id = module.vpc.vpc_id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  tags = {
    Type = "public"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                    = local.vpc_name
  cidr                    = local.cidr
  map_public_ip_on_launch = true
  enable_dns_support      = true
  enable_dns_hostnames    = true

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 8)]

  public_subnet_tags = {
    Type = "public"
  }

  private_subnet_tags = {
    Type = "private"
  }

  enable_nat_gateway = false
  single_nat_gateway = false

  tags = var.tags
}
