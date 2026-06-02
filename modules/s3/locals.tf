locals {
  name          = var.name != null ? var.name : var.product
  bucket        = var.use_prefix ? null : local.name
  bucket_prefix = var.use_prefix ? "${local.name}-" : null

  create_replication_role = length(var.replication_configuration_set) != 0 || var.replication_configuration_shortcut != null
  replication_role        = local.create_replication_role ? aws_iam_role.replication_role[0].name : null

  replication_configuration_set = length(var.replication_configuration_set) != 0 ? var.replication_configuration_set : var.replication_configuration_shortcut == null ? toset([]) : toset([{
    role = aws_iam_role.replication_role[0].arn
    rules = [{
      id                                           = "${local.name}-replication_rule"
      priority                                     = 0
      status                                       = "Enabled"
      destination_account_id                       = var.replication_configuration_shortcut.destination_account_id
      destination_bucket                           = var.replication_configuration_shortcut.destination_bucket
      destination_access_control_translation_owner = "Destination"
    }]
    }
  ])

  destination_bucket = length(local.replication_configuration_set) == 0 ? null : tolist(tolist(local.replication_configuration_set)[0].rules)[0].destination_bucket

  object_ownership = var.acl != null ? "BucketOwnerPreferred" : "BucketOwnerEnforced"

  inventory_bucket_prefix = var.inventory_config == null ? null : var.inventory_config.destination.bucket.prefix != null ? var.inventory_config.destination.bucket.prefix : data.aws_caller_identity.current.account_id

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
