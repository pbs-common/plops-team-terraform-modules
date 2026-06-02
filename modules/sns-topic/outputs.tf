output "name" {
  description = "Name of the SNS Topic"
  value       = local.name
}

output "arn" {
  description = "ARN of the SNS Topic"
  value       = aws_sns_topic.topic.arn
}
