data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name_prefix = "${local.name}-"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "${local.name} Task Role"
    application = var.product
    environment = var.environment
    creator     = local.creator
    repo        = var.repo
  }
}

data "aws_iam_policy_document" "policy_doc" {
  count = var.role_policy_json == null ? 1 : 0
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "kms:ListKeys",
      "ssm:DescribeParameters",
      "ecs:ExecuteCommand",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr-public:GetAuthorizationToken",
      "sts:GetServiceBearerToken",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}*",
    ]
  }
}

data "aws_iam_policy_document" "vgw_policy_doc" {
  count = var.role_policy_json == null && local.use_virtual_gateway_def ? 1 : 0
  statement {
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "appmesh:StreamAggregatedResources"
    ]
    resources = ["arn:aws:appmesh:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:mesh/${var.mesh_name}/virtualGateway/${var.virtual_gateway}"]
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr-public:GetAuthorizationToken",
      "sts:GetServiceBearerToken",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  name_prefix = "${local.name}-"
  role        = aws_iam_role.task_role.name

  policy = local.role_policy_json
}

resource "aws_iam_role" "task_execution_role" {
  name_prefix = "${local.name}-exec-"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "${local.name} Task Role"
    application = var.product
    environment = var.environment
    creator     = local.creator
    repo        = var.repo
  }
}

data "aws_iam_policy_document" "task_execution_role_policy_doc" {
  count = var.task_execution_role_policy_json == null ? 1 : 0
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path}*",
    ]
  }

  dynamic "statement" {
    for_each = local.use_newrelic_firelens_sidecar ? [local.newrelic_secret_arn] : []
    content {
      actions   = ["secretsmanager:GetSecretValue"]
      resources = [statement.value]
    }
  }

  dynamic "statement" {
    for_each = var.use_cwagent_sidecar == true ? [1] : []
    content {
      actions   = ["ssm:GetParameters"]
      resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/ecs-cwagent"]
    }
  }
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name_prefix = "${local.name}-"
  role        = aws_iam_role.task_execution_role.name

  policy = local.task_execution_role_policy_json
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  count = var.use_cwagent_sidecar ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.task_role.name
}

resource "aws_iam_policy" "extra_role_policy" {
  count = var.extra_role_policy_json != null ? 1 : 0

  name        = "${local.name}-extra-role-policy"
  description = "Extra role policy"
  policy      = var.extra_role_policy_json
}

resource "aws_iam_role_policy_attachment" "extra_role_policy" {
  count = var.extra_role_policy_json != null ? 1 : 0

  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.extra_role_policy[0].arn
}

resource "aws_iam_policy" "extra_task_execution_role_policy" {
  count = var.extra_task_execution_role_policy_json != null ? 1 : 0

  name        = "${local.name}-extra-task-execution-policy"
  description = "Extra role policy"
  policy      = var.extra_task_execution_role_policy_json
}

resource "aws_iam_role_policy_attachment" "extra_task_execution_role_policy" {
  count = var.extra_task_execution_role_policy_json != null ? 1 : 0

  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.extra_task_execution_role_policy[0].arn
}
