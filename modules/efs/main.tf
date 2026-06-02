resource "aws_security_group" "sg" {
  count       = local.create_security_group ? 1 : 0
  description = "Controls access to the ${local.name} EFS"

  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.product} EFS SG"
    application = var.product
    environment = var.environment
    creator     = local.creator
    repo        = var.repo
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  encrypted      = var.is_encrypted
  kms_key_id     = var.kms_key_id

  lifecycle_policy {
    transition_to_ia = var.lifecycle_policy
  }

  performance_mode = var.performance_mode

  throughput_mode                 = var.provisioned_throughput_in_mibps == null ? "provisioned" : "bursting"
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps > 0 ? var.provisioned_throughput_in_mibps : null

  tags = local.tags
}

resource "aws_efs_mount_target" "mount_target" {
  for_each        = toset(local.subnets)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = local.security_groups

}
