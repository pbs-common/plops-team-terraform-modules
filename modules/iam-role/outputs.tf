output "arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.role.arn
}

output "name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.role.name
}

