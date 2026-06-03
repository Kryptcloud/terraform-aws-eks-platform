output "cluster_name" {
  value       = aws_eks_cluster.krypt.name
  description = "The name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.krypt.endpoint
  description = "The endpoint URL for my Kubernetes API server"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.krypt.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with my cluster"
}
