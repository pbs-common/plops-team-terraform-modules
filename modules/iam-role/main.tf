resource "aws_iam_role" "role" {
  name                 = local.role
  name_prefix          = local.role_prefix
  assume_role_policy   = local.assume_role_policy
  permissions_boundary = var.permissions_boundary_arn
  path                 = var.path

  tags = local.tags
}

resource "aws_iam_policy" "policy" {
  name_prefix = "${local.name}-policy-"
  policy      = var.policy_json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = local.name
  role  = aws_iam_role.role.name
}
