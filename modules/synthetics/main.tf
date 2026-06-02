resource "aws_synthetics_canary" "canary" {
  name            = local.name
  runtime_version = var.runtime_version

  schedule {
    expression          = var.schedule.expression
    duration_in_seconds = var.schedule.duration_in_seconds
  }

  artifact_s3_location = local.artifact_s3_location
  execution_role_arn   = local.execution_role_arn
  handler              = var.handler

  # Optional configs
  delete_lambda = var.delete_lambda

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [1] : []
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  failure_retention_period = var.failure_retention_period

  dynamic "run_config" {
    for_each = var.run_config != null ? [1] : []
    content {
      timeout_in_seconds    = var.run_config.timeout_in_seconds
      memory_in_mb          = var.run_config.memory_in_mb
      active_tracing        = var.run_config.active_tracing
      environment_variables = var.run_config.environment_variables
    }
  }

  s3_bucket  = var.canary_script_s3_location.bucket
  s3_key     = var.canary_script_s3_location.key
  s3_version = var.canary_script_s3_location.version

  zip_file = var.zip_file

  start_canary             = var.start_canary
  success_retention_period = var.success_retention_period

  dynamic "artifact_config" {
    for_each = var.artifact_config != null ? [1] : []
    content {
      dynamic "s3_encryption" {
        for_each = var.artifact_config.s3_encryption != null ? [1] : []
        content {
          encryption_mode = var.artifact_config.s3_encryption.encryption_mode
          kms_key_arn     = var.artifact_config.s3_encryption.kms_key_arn
        }
      }
    }
  }

  tags = local.tags
}
