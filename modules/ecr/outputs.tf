output "repository_url" {
  value       = aws_ecr_repository.krypt.repository_url
  description = "The URL endpoint of the private ECR container registry"
}
