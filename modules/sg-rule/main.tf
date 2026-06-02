
locals {
  ingress_source_cidr_blocks      = contains(["ingress", "all"], var.type) ? { for cidr in coalesce(var.source_cidr_blocks, []) : cidr => cidr } : {}
  ingress_source_ipv6_cidr_blocks = contains(["ingress", "all"], var.type) ? { for cidr in coalesce(var.source_ipv6_cidr_blocks, []) : cidr => cidr } : {}
  egress_source_cidr_blocks       = contains(["egress", "all"], var.type) ? { for cidr in coalesce(var.source_cidr_blocks, []) : cidr => cidr } : {}
  egress_source_ipv6_cidr_blocks  = contains(["egress", "all"], var.type) ? { for cidr in coalesce(var.source_ipv6_cidr_blocks, []) : cidr => cidr } : {}
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_cidrv4" {
  for_each = local.ingress_source_cidr_blocks

  security_group_id = var.security_group_id
  description       = var.description

  cidr_ipv4   = each.value
  from_port   = local.from_port
  ip_protocol = var.protocol
  to_port     = local.to_port

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_cidrv6" {
  for_each = local.ingress_source_ipv6_cidr_blocks

  security_group_id = var.security_group_id
  description       = var.description

  cidr_ipv6   = each.value
  from_port   = local.from_port
  ip_protocol = var.protocol
  to_port     = local.to_port

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_sg" {
  count = contains(["ingress", "all"], var.type) ? 1 : 0

  security_group_id = var.security_group_id
  description       = var.description

  referenced_security_group_id = var.source_security_group_id
  from_port                    = local.from_port
  ip_protocol                  = var.protocol
  to_port                      = local.to_port

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_cidrv4" {
  for_each = local.egress_source_cidr_blocks

  security_group_id = var.security_group_id
  description       = var.description

  cidr_ipv4   = each.value
  from_port   = local.from_port
  ip_protocol = var.protocol
  to_port     = local.to_port

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_cidrv6" {
  for_each = local.egress_source_ipv6_cidr_blocks

  security_group_id = var.security_group_id
  description       = var.description

  cidr_ipv6   = each.value
  from_port   = local.from_port
  ip_protocol = var.protocol
  to_port     = local.to_port

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_sg" {
  count = contains(["egress", "all"], var.type) ? 1 : 0

  security_group_id = var.security_group_id
  description       = var.description

  referenced_security_group_id = var.source_security_group_id
  from_port                    = local.from_port
  ip_protocol                  = var.protocol
  to_port                      = local.to_port

  tags = local.tags
}
