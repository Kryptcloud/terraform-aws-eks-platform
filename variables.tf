variable "environment" {
  type        = string
  description = "deployment environment name"
}


variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "name of the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for the public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for the private subnets"
}

variable "allowed_ssh_cidr" {
  type        = list(string)
  description = "List of CIDR blocks that are allowed to access the resources through SSH (port 22)"
  default     = ["0.0.0.0/0"]
}


variable "instance_types" {
  type        = list(string)
  description = "The EC2 instance types for EKS worker nodes"
}


variable "ecr_name" {
  type        = string
  description = "name of the ECR repository"
}