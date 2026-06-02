locals {
  name                  = var.name != null ? var.name : var.product
  vpc_id                = var.vpc_id != null ? var.vpc_id : data.aws_vpc.vpc[0].id
  subnets               = var.subnets != null ? var.subnets : data.aws_subnets.private_subnets[0].ids
  create_security_group = length(var.security_groups) <= 0
  security_groups       = local.create_security_group ? [aws_security_group.sg[0].id] : var.security_groups

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
