output "arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.cluster.arn
}

output "name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.cluster.name
}
