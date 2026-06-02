resource "aws_s3_bucket_inventory" "inventory_prefix" {
  count = var.inventory_config != null ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  name   = var.inventory_config.destination.bucket.name

  enabled = var.inventory_config.enabled

  included_object_versions = var.inventory_config.included_object_versions

  schedule {
    frequency = var.inventory_config.schedule.frequency
  }

  dynamic "filter" {
    for_each = var.inventory_config.filter != null ? [var.inventory_config.filter] : []
    content {
      prefix = filter.value.prefix
    }
  }

  optional_fields = var.inventory_config.optional_fields

  destination {
    bucket {
      format     = var.inventory_config.destination.bucket.format
      bucket_arn = "arn:aws:s3:::${var.inventory_config.destination.bucket.name}"
      prefix     = local.inventory_bucket_prefix
      account_id = var.inventory_config.destination.bucket.account_id
    }
  }
}
