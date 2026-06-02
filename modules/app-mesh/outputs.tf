output "id" {
  description = "The ID of the service mesh."
  value       = aws_appmesh_mesh.mesh.id
}

output "name" {
  description = "The name of the service mesh."
  value       = aws_appmesh_mesh.mesh.name
}

output "arn" {
  description = "The ARN of the service mesh."
  value       = aws_appmesh_mesh.mesh.arn
}
