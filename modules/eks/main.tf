resource "aws_eks_cluster" "krypt" {
  name     = "${var.environment}-eks-cluster"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = true  # Set to true for easy access from my local machine terminal
    endpoint_private_access = true  # Allows nodes to communicate with the API server securely inside the VPC
  }

  # Ensure that IAM Role permissions are created before and stripped after EKS Cluster handling
  depends_on = [
    var.cluster_role_arn
  ]

  tags = {
    Name        = "${var.environment}-eks-cluster"
    Environment = var.environment
  }
}
