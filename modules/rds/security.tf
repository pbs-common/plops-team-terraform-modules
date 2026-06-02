resource "aws_security_group" "sg" {
  description = var.sg_description != null ? var.sg_description : "Controls access to the ${local.name} DB"
  vpc_id      = local.vpc_id
  name        = var.sg_name
  name_prefix = var.sg_name == null ? "${local.name}-db-sg-" : null

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name} DB SG"
    }
  )
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.sg.id
  description       = "Allow all traffic out"
  type              = "egress"
  protocol          = "-1"

  from_port = 0
  to_port   = 0

  source_security_group_id = var.egress_source_sg_id
  cidr_blocks              = var.egress_source_sg_id == null ? var.egress_cidr_blocks : null
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id        = aws_security_group.sg.id
  type                     = "ingress"
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_iam_role" "proxy_role" {
  count       = var.use_proxy ? 1 : 0
  name        = var.use_prefix ? null : local.proxy_name
  name_prefix = var.use_prefix ? local.proxy_name : null
  description = "Role for the ${local.proxy_name} DB proxy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    local.tags,
    {
      "Name" = "${local.proxy_name} DB Role"
    }
  )
}

resource "aws_secretsmanager_secret" "proxy_secret" {
  count       = var.use_proxy ? 1 : 0
  name        = var.use_prefix ? null : local.proxy_name
  name_prefix = var.use_prefix ? local.proxy_name : null
  description = "Secret for the ${local.proxy_name} DB proxy"

  tags = merge(
    local.tags,
    {
      "Name" = "${local.proxy_name} DB Secret"
    }
  )
}

resource "aws_secretsmanager_secret_version" "proxy_secret_version" {
  count     = var.use_proxy ? 1 : 0
  secret_id = aws_secretsmanager_secret.proxy_secret[0].id
  secret_string = jsonencode({
    username            = local.proxy_username,
    password            = local.proxy_password,
    engine              = lower(local.proxy_engine_family),
    host                = aws_rds_cluster.db.endpoint
    dbClusterIdentifier = aws_rds_cluster.db.id
  })
}

resource "aws_iam_role_policy" "proxy_policy" {
  count       = var.use_proxy ? 1 : 0
  name        = var.use_prefix ? null : local.proxy_name
  name_prefix = var.use_prefix ? local.proxy_name : null
  role        = aws_iam_role.proxy_role[0].id
  policy      = data.aws_iam_policy_document.proxy_policy[0].json
}

data "aws_kms_key" "proxy_kms_key" {
  count  = var.use_proxy ? 1 : 0
  key_id = var.proxy_kms_key_id
}

data "aws_iam_policy_document" "proxy_policy" {
  count = var.use_proxy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.proxy_secret[0].arn,
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      data.aws_kms_key.proxy_kms_key[0].arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "secretsmanager.${data.aws_region.current.region}.amazonaws.com",
      ]
    }
  }
}



resource "aws_security_group" "proxy_sg" {
  count       = var.use_proxy ? 1 : 0
  description = "Controls access to the ${local.proxy_name} DB proxy"
  vpc_id      = local.vpc_id
  name_prefix = "${local.name}-db-proxy-sg-"

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name} DB proxy SG"
    }
  )
}

resource "aws_security_group_rule" "proxy_egress" {
  count             = var.use_proxy ? 1 : 0
  security_group_id = aws_security_group.proxy_sg[0].id
  description       = "Allow all traffic out"
  type              = "egress"
  protocol          = "-1"

  from_port = 0
  to_port   = 0

  source_security_group_id = var.egress_source_sg_id
  cidr_blocks              = var.egress_source_sg_id == null ? var.egress_cidr_blocks : null
}

resource "aws_security_group_rule" "proxy_to_db" {
  count             = var.use_proxy ? 1 : 0
  security_group_id = aws_security_group.sg.id
  description       = "Allow traffic from the proxy to the DB"
  type              = "ingress"
  protocol          = "tcp"

  from_port = aws_rds_cluster.db.port
  to_port   = aws_rds_cluster.db.port

  source_security_group_id = aws_security_group.proxy_sg[0].id
}
