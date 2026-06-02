output "arn" {
  description = "ARN of the subscription"
  value       = aws_sns_topic_subscription.subscription.arn
}
