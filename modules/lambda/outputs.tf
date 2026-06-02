output "arn" {
  description = "ARN of the lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "name" {
  description = "Name of the lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "invoke_arn" {
  description = "Invocation ARN of the lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "qualified_arn" {
  description = "Qualified ARN of the lambda function"
  value       = aws_lambda_function.lambda.qualified_arn
}

output "sg" {
  description = "Security group of the lambda function if there is one"
  value       = local.security_group_id
}
