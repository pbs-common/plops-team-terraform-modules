locals {
  allow_lambda_access_statement = {
    "Sid" : "LambdaECRImageRetrievalPolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "lambda.amazonaws.com"
    },
    "Action" : [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
  ecr_statements = [
    for statement in [
      var.allow_lambda_access ? local.allow_lambda_access_statement : null
    ] : statement if statement != null
  ]
}

resource "aws_ecr_repository_policy" "policy" {
  count = var.create_ecr_policy ? 1 : 0

  repository = aws_ecr_repository.repo.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : local.ecr_statements,
    }
  )
}
