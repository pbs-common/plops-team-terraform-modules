resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier         = aws_rds_cluster.db.id
  identifier                 = var.writer_identifier != null ? var.writer_identifier : "${local.name}-instance-1"
  instance_class             = var.instance_class
  db_parameter_group_name    = aws_db_parameter_group.this.name
  apply_immediately          = var.apply_immediately
  engine                     = var.engine
  engine_version             = local.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  copy_tags_to_snapshot      = var.instance_copy_tags_to_snapshot

  tags = local.tags
}

resource "aws_rds_cluster_instance" "reader" {
  count                      = var.reader_count
  cluster_identifier         = aws_rds_cluster.db.id
  identifier                 = var.reader_identifier_prefix != null ? "${var.reader_identifier_prefix}${count.index + 1}" : "${local.name}-instance-${count.index + 2}"
  instance_class             = var.instance_class
  db_parameter_group_name    = aws_db_parameter_group.this.name
  apply_immediately          = var.apply_immediately
  engine                     = var.engine
  engine_version             = local.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  copy_tags_to_snapshot      = var.instance_copy_tags_to_snapshot

  tags = local.tags
}
