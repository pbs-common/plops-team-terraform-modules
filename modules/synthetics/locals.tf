locals {
  name = var.name != null ? var.name : var.product

  execution_role_arn = var.execution_role_arn != null ? var.execution_role_arn : module.role[0].arn

  artifact_s3_location = "s3://${module.s3.name}/"

  snapshot_bucket_name = var.snapshot_bucket_name != null ? var.snapshot_bucket_name : local.name
  execution_role_name  = var.execution_role_name != null ? var.execution_role_name : local.name

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
