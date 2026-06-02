data "aws_iam_policy_document" "default_policy_document" {
  count = var.policy_json != null ? 0 : 1
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${local.log_group_name}:*",
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda-insights:*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "ssm:GetParameter",
      "ssm:GetParametersByPath",
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}",
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}*"
    ]
  }

  dynamic "statement" {
    for_each = local.create_security_group ? [local.create_security_group] : []
    content {
      actions = [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.allow_app_config_access ? [var.allow_app_config_access] : []
    content {
      actions = [
        "appconfig:StartConfigurationSession",
        "appconfig:GetLatestConfiguration",
      ]
      resources = ["*"]
    }
  }
}

module "default_role" {
  count  = var.role_arn != null ? 0 : 1
  source = "github.com/pbs/terraform-aws-iam-role-module?ref=1.0.0"

  name = local.name

  policy_json = local.policy_json

  use_prefix               = var.use_prefix
  permissions_boundary_arn = var.permissions_boundary_arn

  aws_services = ["lambda", "edgelambda"]

  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
  organization = var.organization
}

resource "aws_security_group" "sg" {
  count       = local.create_security_group ? 1 : 0
  description = "Controls access to the ${local.name} lambda function"

  vpc_id      = local.vpc_id
  name_prefix = "${local.name}-sg-"

  tags = merge(
    local.tags,
    { Name = "${local.name} SG" },
  )
}

resource "aws_security_group_rule" "egress" {
  count             = local.create_security_group ? 1 : 0
  description       = "Allow all outbound traffic"
  security_group_id = local.security_group_id
  type              = "egress"
  protocol          = "-1"

  from_port = 0
  to_port   = 0

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
