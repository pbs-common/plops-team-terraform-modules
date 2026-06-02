output "name" {
  description = "The name of the ElastiCache cluster"
  value       = aws_elasticache_cluster.cluster.cluster_id
}

output "arn" {
  description = "The ARN of the ElastiCache cluster"
  value       = aws_elasticache_cluster.cluster.arn
}

output "sg_ids" {
  description = "The security group ids"
  value       = local.security_group_ids
}


output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone"
  value       = aws_elasticache_cluster.cluster.cache_nodes
}

output "cluster_address" {
  description = "DNS name of the cache cluster without the port appended"
  value       = aws_elasticache_cluster.cluster.cluster_address
}

output "configuration_endpoint" {
  description = "Configuration endpoint to allow host discovery"
  value       = aws_elasticache_cluster.cluster.configuration_endpoint
}

output "tags" {
  description = "The tags"
  value       = local.tags
}
