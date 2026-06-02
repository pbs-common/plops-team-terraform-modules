locals {
  name    = var.name != null ? var.name : var.product
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

  # Default retention values per environment
  default_retention_values = {
    sharedtools = 5
    dev         = 10
    qa          = 15
    staging     = 20
    prod        = 35
  }

  # Effective number of images to retain
  # Priority: images_to_retain > environment default
  effective_images_to_retain = coalesce(
    var.images_to_retain,                                       # First priority: explicit images_to_retain
    try(local.default_retention_values[var.environment], null), # Second priority: actual environment default
  )
}

data "aws_default_tags" "common_tags" {}
