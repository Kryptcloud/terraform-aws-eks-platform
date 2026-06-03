variable "environment" {
  type        = string
  description = "The deployment environment name"
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "node_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the worker nodes"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where nodes will run"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"] # Standard reliable size for EKS testing
  description = "The EC2 instance type for the worker nodes"
}
