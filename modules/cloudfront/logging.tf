resource "aws_cloudwatch_log_delivery_source" "delivery_source" {
  count        = var.v2_logging != null ? 1 : 0
  name         = "${local.name}-cf-delivery-source"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.cdn.arn
}

resource "aws_cloudwatch_log_delivery_destination" "delivery_destination" {
  count         = var.v2_logging != null ? 1 : 0
  name          = "s3-log-destination-${local.name}-cfront"
  output_format = var.v2_logging.output_format
  delivery_destination_configuration {
    destination_resource_arn = "${var.v2_logging.s3_bucket_arn}/${var.v2_logging.s3_prefix}"
  }
}

resource "aws_cloudwatch_log_delivery" "log_delivery" {
  count                    = var.v2_logging != null ? 1 : 0
  delivery_source_name     = aws_cloudwatch_log_delivery_source.delivery_source[0].name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.delivery_destination[0].arn
  field_delimiter          = var.v2_logging.field_delimiter
  record_fields            = local.merged_record_fields

  s3_delivery_configuration {
    suffix_path                 = var.v2_logging.suffix_path
    enable_hive_compatible_path = var.v2_logging.enable_hive_compatible_path
  }
}