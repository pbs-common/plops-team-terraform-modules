resource "aws_iam_role" "replication_role" {
  count              = local.create_replication_role ? 1 : 0
  name               = "${local.name}-replication"
  assume_role_policy = data.aws_iam_policy_document.s3_assume_role_policy[0].json
}

resource "aws_iam_role_policy" "replication_policy" {
  count = local.create_replication_role ? 1 : 0
  name  = "${local.name}-replication"
  role  = aws_iam_role.replication_role[0].id

  policy = jsonencode({
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [

          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"

        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Resource" : "arn:aws:s3:::${local.destination_bucket}/*"
      },
    ]
    Version = "2012-10-17"
  })
}

module "s3_policy" {
  source = "github.com/pbs/terraform-aws-s3-bucket-policy-module?ref=2.0.0"
  count  = var.create_bucket_policy ? 1 : 0

  name = aws_s3_bucket.bucket.id

  bucket_policy = var.bucket_policy

  force_tls = var.force_tls

  allow_anonymous_vpce_access = var.allow_anonymous_vpce_access
  vpce                        = var.vpce

  replication_source = var.replication_source

  cloudfront_oac_access_statements = var.cloudfront_oac_access_statements

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  product = var.product
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
