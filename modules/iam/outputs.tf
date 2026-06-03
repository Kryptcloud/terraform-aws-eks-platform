output "eks_cluster_role_arn" {
  value       = aws_iam_role.eks_cluster.arn
  description = "The Amazon Resource Name (ARN) of the EKS Cluster role"
}

output "eks_node_group_role_arn" {
  value       = aws_iam_role.eks_nodes.arn
  description = "The Amazon Resource Name (ARN) of the EKS Worker Node role"
}
