resource "aws_db_subnet_group" "subnet_group" {
  name        = var.subnet_group_name
  name_prefix = var.subnet_group_name == null ? "${local.name}-db-subnet-group-" : null
  subnet_ids  = local.private_subnets

  tags = merge(
    local.tags,
    {
      Name = "${local.name} DB Subnet Group"
    }
  )
}
