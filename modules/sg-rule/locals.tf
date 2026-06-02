locals {
  from_port = var.from_port != null ? var.from_port : var.port
  to_port   = var.to_port != null ? var.to_port : var.port

  defaulted_tags = merge(
    var.tags,
    {
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = "terraform"
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
