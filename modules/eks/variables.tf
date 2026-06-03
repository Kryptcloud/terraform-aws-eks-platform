variable "environment" {
  type        = string
  description = "The deployment environment name"
}

variable "cluster_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the EKS Cluster control plane"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where the EKS control plane will place interfaces"
}
