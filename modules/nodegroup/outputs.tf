output "node_group_id" {
  value       = aws_eks_node_group.krypt.id
  description = "The ID of the EKS Node Group"
}
