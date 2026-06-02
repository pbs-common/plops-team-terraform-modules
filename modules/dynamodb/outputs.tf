output "arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.table.arn
}

output "name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.table.id
}
