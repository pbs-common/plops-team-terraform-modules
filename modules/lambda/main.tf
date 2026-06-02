resource "aws_lambda_function" "lambda" {
  function_name    = local.name
  description      = local.description
  role             = local.role
  handler          = var.handler
  filename         = var.filename
  source_code_hash = local.source_code_hash
  image_uri        = var.image_uri
  package_type     = var.package_type
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  publish          = var.publish
  layers           = local.layers
  architectures    = var.architectures
  dynamic "environment" {
    for_each = local.environment_map
    content {
      variables = environment.value
    }
  }
  dynamic "tracing_config" {
    for_each = var.tracing_config_mode != "Disabled" ? [var.tracing_config_mode] : []
    content {
      mode = var.tracing_config_mode
    }
  }
  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? [var.file_system_config] : []
    content {
      arn              = var.file_system_config["arn"]
      local_mount_path = var.file_system_config["local_mount_path"]
    }
  }
  dynamic "vpc_config" {
    for_each = var.add_vpc_config ? [var.add_vpc_config] : []
    content {
      security_group_ids = [local.security_group_id]
      subnet_ids         = local.subnet_ids
    }
  }
  ephemeral_storage {
    size = var.ephemeral_storage_size
  }
  tags = local.tags

  depends_on = [
    aws_cloudwatch_log_group.log_group
  ]
}
