output "arn" {
  description = "ARN of the alarm provisioned"
  value       = aws_cloudwatch_metric_alarm.alarm.arn
}

output "name" {
  description = "Name of the alarm provisioned"
  value       = aws_cloudwatch_metric_alarm.alarm.alarm_name
}
