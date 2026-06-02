locals {
  log_name = "/ecs/${local.service_name}"
}

resource "aws_cloudwatch_log_group" "logs" {
  count = var.log_group_name == null ? 1 : 0

  name = local.log_name

  retention_in_days = var.retention_in_days

  log_group_class = var.log_group_class

  tags = {
    Name        = "${local.service_name} Log Group"
    application = var.product
    environment = var.environment
    creator     = local.creator
  }
}
