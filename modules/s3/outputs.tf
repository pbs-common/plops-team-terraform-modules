output "name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "regional_domain_name" {
  description = "Regional domain name"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "replication_role" {
  description = "Replication role if exists"
  value       = local.replication_role
}
