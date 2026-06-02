output "arn" {
  description = "EFS ARN"
  value       = aws_efs_file_system.efs.arn
}

output "id" {
  description = "EFS ID"
  value       = aws_efs_file_system.efs.id
}

output "dns_name" {
  description = "EFS DNS name"
  value       = aws_efs_file_system.efs.dns_name
}

output "sgs" {
  description = "Security groups"
  value       = local.security_groups
}
