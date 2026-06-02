data "aws_availability_zones" "available" {
  count = var.availability_zones == null ? 1 : 0
  state = "available"
}

data "aws_vpc" "vpc" {
  count = var.vpc_id == null ? 1 : 0
  tags = {
    "Name" : "*${var.environment}*"
  }
}

data "aws_subnets" "private_subnets" {
  count = var.private_subnets == null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*-private-*"]
  }
}

data "aws_route53_zone" "private_hosted_zone" {
  count        = var.create_dns ? 1 : 0
  name         = "${var.private_hosted_zone}."
  private_zone = true
}

data "aws_rds_engine_version" "engine_version" {
  count              = var.engine_version == null ? 1 : 0
  engine             = var.engine
  preferred_versions = var.engine_preferred_versions
}

data "aws_region" "current" {}
