output "arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.task_def.arn
}

output "role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.task_role.arn
}

output "container_definitions" {
  description = "Task definition container definitions"
  value       = local.container_definitions
}
