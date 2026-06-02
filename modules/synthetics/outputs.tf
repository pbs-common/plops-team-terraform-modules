output "arn" {
  description = "ARN of the canary"
  value       = aws_synthetics_canary.canary.arn
}

output "engine_arn" {
  description = "ARN of the Lambda function that is used as your canary's engine"
  value       = aws_synthetics_canary.canary.engine_arn
}

output "id" {
  description = "Name of the canary"
  value       = aws_synthetics_canary.canary.id
}

output "name" {
  description = "Name of the canary"
  value       = aws_synthetics_canary.canary.id
}

output "source_location_arn" {
  description = "ARN of the Lambda layer where Synthetics stores the canary script code"
  value       = aws_synthetics_canary.canary.source_location_arn
}

output "status" {
  description = "Status of the canary"
  value       = aws_synthetics_canary.canary.status
}

output "timeline" {
  description = "Timeline of the canary"
  value       = aws_synthetics_canary.canary.timeline
}

output "execution_role_name" {
  description = "Name of the IAM role used to run the canary"
  value       = module.role[0].name
}
