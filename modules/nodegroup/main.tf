resource "aws_eks_node_group" "krypt" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.instance_types

  scaling_config {
    desired_size = 2 # Starts with 2 servers
    max_size     = 4 # Can grow up to 4 if traffic spikes
    min_size     = 1 # Never drop below 1 server
  }

  update_config {
    max_unavailable = 1 # Safe rolling updates (updates 1 server at a time)
  }

  tags = {
    Name        = "${var.environment}-worker-node"
    Environment = var.environment
  }
}
