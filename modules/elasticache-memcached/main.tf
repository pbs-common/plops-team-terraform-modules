resource "aws_elasticache_cluster" "cluster" {
  cluster_id           = local.name
  engine               = local.engine
  node_type            = var.node_type
  num_cache_nodes      = var.nodes
  parameter_group_name = var.parameter_group_name == null ? module.aws_elasticache_parameter_group[0].name : var.parameter_group_name

  apply_immediately = var.apply_immediately

  az_mode                      = var.az_mode
  availability_zone            = var.availability_zone
  preferred_availability_zones = var.preferred_availability_zones

  engine_version         = var.engine_version
  maintenance_window     = var.maintenance_window
  notification_topic_arn = var.notification_topic_arn
  port                   = var.port
  security_group_ids     = local.security_group_ids
  subnet_group_name      = local.subnet_group_name

  tags = local.tags
}

module "aws_elasticache_parameter_group" {
  count  = var.parameter_group_name == null ? 1 : 0
  source = "github.com/pbs/terraform-aws-elasticache-parameter-group-module?ref=1.1.1"

  name                    = local.name
  engine                  = local.engine
  parameter_group_version = local.parameter_group_version
  organization            = var.organization
  environment             = var.environment
  product                 = var.product
  owner                   = var.owner
  repo                    = var.repo
}