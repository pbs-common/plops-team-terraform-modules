output "name" {
  description = "Name of the virtual service"
  value       = aws_appmesh_virtual_service.virtual_service.name
}

output "arn" {
  description = "ARN of the virtual service"
  value       = aws_appmesh_virtual_service.virtual_service.arn
}

output "id" {
  description = "ID of the virtual service"
  value       = aws_appmesh_virtual_service.virtual_service.id
}
