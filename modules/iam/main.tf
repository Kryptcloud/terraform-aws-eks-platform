# 1. EKS CLUSTER CONTROL PLANE IAM ROLE

# Define the trust policy allowing EKS service to assume this role
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Create the EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster" {
  name               = "${var.environment}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name        = "${var.environment}-eks-cluster-role"
    Environment = var.environment
  }
}

# Attach the mandatory AmazonEKSClusterPolicy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}



# 2. EKS WORKER NODE GROUP IAM ROLE


# Define the trust policy allowing EC2 instances to assume this role
data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create the EKS Worker Node IAM Role
resource "aws_iam_role" "eks_nodes" {
  name               = "${var.environment}-eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json

  tags = {
    Name        = "${var.environment}-eks-node-group-role"
    Environment = var.environment
  }
}

# Attachment 1: Mandatory policy for worker node cluster communication
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

# Attachment 2: Mandatory policy for the Amazon VPC CNI networking plugin
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

# Attachment 3: Mandatory policy to allow downloading Docker images from private ECR registries
resource "aws_iam_role_policy_attachment" "amazon_ecr_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}


# 3. AWS LOAD BALANCER CONTROLLER IAM ROLE (IRSA)

# Fetch the official AWS Load Balancer Controller IAM Policy from the internet
data "http" "alb_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

# Create the dedicated IAM Policy for the controller
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${var.environment}-aws-load-balancer-controller-policy"
  description = "Permissions required by the AWS Load Balancer Controller pod in EKS"
  policy      = data.http.alb_controller_policy.response_body
}

# Trust policy using OIDC provider so the K8s service account can assume this AWS role safely
data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn] # Pass this from your core EKS module output
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

# Create the IAM Role for the controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = "${var.environment}-aws-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
  role       = aws_iam_role.aws_load_balancer_controller.name
}