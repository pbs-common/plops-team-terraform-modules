data "aws_iam_policy_document" "assume_role_policy" {
  count = local.generate_assume_role_policy ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [for service in var.aws_services : "${service}.amazonaws.com"]
    }
  }
}
