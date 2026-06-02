output "name" {
  description = "Name of the virtual gateway"
  value       = aws_appmesh_virtual_gateway.gateway.name
}

output "arn" {
  description = "ARN of the virtual gateway"
  value       = aws_appmesh_virtual_gateway.gateway.arn
}

output "domain_name" {
  description = "Domain name of the service backing the virtual gateway"
  value       = module.envoy_service.domain_name
}

output "service_sg" {
  description = "SG of the service backing the virtual gateway"
  value       = module.envoy_service.service_sg
}
