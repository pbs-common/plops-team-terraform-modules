output "name" {
  description = "Name of the DB"
  value       = aws_rds_cluster.db.id
}

output "db_admin_username" {
  description = "Admin username for DB"
  value       = var.db_admin_username
  sensitive   = true
}

output "db_admin_password" {
  description = "Admin password for DB"
  value       = random_password.password.result
  sensitive   = true
}

output "db_cluster_dns" {
  description = "Private DNS record for the DB Cluster endpoint (if create_dns is true, otherwise the endpoint itself)"
  value       = local.db_cluster_dns
}

output "db_cluster_reader_dns" {
  description = "Private DNS record for the DB Cluster reader endpoint (if create_dns is true, otherwise the endpoint itself)"
  value       = local.db_cluster_reader_dns
}

output "db_admin_dns" {
  description = "DNS endpoint for performing administrative tasks on the database, i.e. the non-proxy writer endpoint for the cluster"
  value       = aws_rds_cluster.db.endpoint
}

output "sg_id" {
  description = "Security group ID for DB. If use_proxy is true, this is the proxy SG, otherwise it's the cluster's security group"
  value       = local.sg_id
}

output "admin_sg_id" {
  description = "The security group id for performing administrative tasks on the database. If use_proxy is false, this is the same as sg_id"
  value       = aws_security_group.sg.id
}

output "cluster_parameter_group_name" {
  value       = aws_rds_cluster_parameter_group.this.name
  description = "The name of the cluster parameter group"
}

output "instance_parameter_group_name" {
  value       = aws_db_parameter_group.this.name
  description = "The name of the instance parameter group"
}

output "parameter_group_family" {
  value       = local.parameter_group_family
  description = "The family type of the parameter groups"
}
