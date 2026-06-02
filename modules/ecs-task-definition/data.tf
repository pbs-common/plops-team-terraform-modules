data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "newrelic_secret" {
  count = local.get_newrelic_secret ? 1 : 0
  name  = var.newrelic_secret_name
}
