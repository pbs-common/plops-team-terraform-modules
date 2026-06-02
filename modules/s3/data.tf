data "aws_iam_policy_document" "s3_assume_role_policy" {
  count = local.create_replication_role ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}
