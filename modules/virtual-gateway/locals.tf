locals {
  name        = var.name != null ? var.name : var.product
  hosted_zone = var.public_service ? var.primary_hosted_zone : var.private_hosted_zone
  vpc_id      = var.vpc_id != null ? var.vpc_id : data.aws_vpc.vpc[0].id
  subnets     = var.subnets != null ? var.subnets : var.public_service ? data.aws_subnets.public_subnets[0].ids : data.aws_subnets.private_subnets[0].ids
  cnames      = var.cnames != null ? var.cnames : [local.name]
  aliases     = var.aliases != null ? var.aliases : ["${local.name}.${local.hosted_zone}"]

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:owner"       = var.owner
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
