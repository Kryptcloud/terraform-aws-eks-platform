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


# Fetch the OIDC issuer certificate thumbprint
data "tls_certificate" "krypt" {
  url = aws_eks_cluster.krypt.identity[0].oidc[0].issuer
}

# Create the OIDC Provider for IAM Identity Federation
resource "aws_iam_openid_connect_provider" "krypt" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.krypt.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.krypt.identity[0].oidc[0].issuer

  tags = {
    Name        = "${var.environment}-eks-oidc-provider"
    Environment = var.environment
  }
}
