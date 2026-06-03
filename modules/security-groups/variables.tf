variable "vpc_id" {
  type = string
  description = "The Id of the VPC where the security group will be created"
}

variable "environment" {
  type = string
  description = "The environment for which the security group is being created (e.g., dev, staging, prod)"
}

variable "allowed_ssh_cidr" {
  type = list(string)
  default = ["0.0.0.0/0"]
  description = "List of CIDR blocks that are allowed to access the resources associated with this security group through SSH (port 22)"
}