output "arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.arn
}

output "id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.id
}

output "domain_name" {
  description = "One domain name that will resolve to this cdn. Might not be a valid alias."
  value       = local.domain_name
}

output "oac_id" {
  description = "ID of the origin access identity"
  value       = local.origin_access_control_id
}

output "default_cache_policy_id" {
  description = "The default cache policy ID"
  value       = local.default_cache_policy_id
}
