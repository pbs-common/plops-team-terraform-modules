resource "aws_db_proxy" "proxy" {
  count                  = var.use_proxy ? 1 : 0
  name                   = local.proxy_name
  debug_logging          = var.proxy_debug_logging
  engine_family          = local.proxy_engine_family
  idle_client_timeout    = var.proxy_idle_client_timeout
  require_tls            = var.proxy_require_tls
  role_arn               = aws_iam_role.proxy_role[0].arn
  vpc_security_group_ids = [aws_security_group.proxy_sg[0].id]
  vpc_subnet_ids         = local.private_subnets

  auth {
    auth_scheme = "SECRETS"
    description = "Secrets Manager secret for RDS proxy"
    iam_auth    = var.proxy_iam_auth
    secret_arn  = aws_secretsmanager_secret.proxy_secret[0].arn
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name} DB proxy"
    }
  )
}

resource "aws_db_proxy_endpoint" "reader" {
  count                  = var.use_proxy ? 1 : 0
  db_proxy_name          = aws_db_proxy.proxy[0].name
  db_proxy_endpoint_name = "${aws_db_proxy.proxy[0].name}-ro"
  target_role            = "READ_ONLY"
  vpc_security_group_ids = [aws_security_group.proxy_sg[0].id]
  vpc_subnet_ids         = local.private_subnets

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name} DB proxy reader endpoint"
    }
  )
}

resource "aws_db_proxy_default_target_group" "default_target_group" {
  count         = var.use_proxy ? 1 : 0
  db_proxy_name = aws_db_proxy.proxy[0].name

  depends_on = [
    aws_rds_cluster_instance.writer,
    aws_rds_cluster_instance.reader,
  ]
}

resource "aws_db_proxy_target" "target" {
  count                 = var.use_proxy ? 1 : 0
  db_cluster_identifier = aws_rds_cluster.db.id
  db_proxy_name         = aws_db_proxy.proxy[0].name
  target_group_name     = aws_db_proxy_default_target_group.default_target_group[0].name
}
