resource "aws_iam_role" "role" {
  count = var.ec2_backed ? 1 : 0
  name  = local.name
  path  = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[0].json
}

resource "aws_iam_role_policy" "role_policy" {
  count       = var.ec2_backed ? 1 : 0
  name_prefix = "${local.name}-"
  role        = aws_iam_role.role[0].name

  policy = local.role_policy_json
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.ec2_backed ? 1 : 0
  name  = local.name
  role  = aws_iam_role.role[0].name
}

resource "aws_security_group" "sg" {
  count       = var.ec2_backed ? 1 : 0
  description = "Controls access to the ${local.name} service resources"
  vpc_id      = local.vpc_id
  name_prefix = "${local.name}-sg-"

  tags = {
    Name        = "${local.name} service SG"
    application = var.product
    environment = var.environment
    creator     = local.creator
    repo        = var.repo
  }
}

## Allow All Traffic out anywhere for egress
resource "aws_security_group_rule" "sg_egress" {
  count             = var.ec2_backed ? 1 : 0
  security_group_id = aws_security_group.sg[0].id
  description       = "Allow all traffic out"
  type              = "egress"
  protocol          = "-1"

  from_port = 0
  to_port   = 0

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
