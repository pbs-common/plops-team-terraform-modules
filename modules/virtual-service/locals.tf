locals {
  name = var.name != null ? var.name : var.product

  virtual_router_name_set = var.virtual_router_name != null ? toset([var.virtual_router_name]) : toset([])
  virtual_node_name_set   = var.virtual_node_name != null ? toset([var.virtual_node_name]) : toset([])

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
