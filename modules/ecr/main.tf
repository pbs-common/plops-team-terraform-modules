resource "aws_ecr_repository" "repo" {
  name                 = local.name
  image_tag_mutability = var.image_tag_mutability

  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_configuration["encryption_type"]
    kms_key         = var.encryption_configuration["kms_key_arn"]
  }

  tags = local.tags
}


resource "aws_ecr_lifecycle_policy" "repo_lifecycle_policy" {
  count      = local.effective_images_to_retain == null ? 0 : 1
  repository = local.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${local.effective_images_to_retain} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${local.effective_images_to_retain}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
  depends_on = [
    aws_ecr_repository.repo,
  ]
}
