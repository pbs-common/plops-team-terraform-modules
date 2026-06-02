output "repo_url" {
  description = "URL for the repository"
  value       = aws_ecr_repository.repo.repository_url
}
