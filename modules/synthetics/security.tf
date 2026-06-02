module "role" {
  count = var.execution_role_arn == null ? 1 : 0

  source = "github.com/pbs/terraform-aws-iam-role-module.git?ref=1.0.0"

  name = local.execution_role_name

  policy_json = var.policy_json != null ? var.policy_json : jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : [
          "${module.s3.arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          module.s3.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cwsyn-${local.name}*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListAllMyBuckets",
          "xray:PutTraceSegments"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : "cloudwatch:PutMetricData",
        "Condition" : {
          "StringEquals" : {
            "cloudwatch:namespace" : "CloudWatchSynthetics"
          }
        }
      }
    ]
  })

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner

  # Optional Parameters
  aws_services = ["lambda"]
}
