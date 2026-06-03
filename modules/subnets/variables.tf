variable "vpc_id" {
  type = string
  description = "ID of the VPC where subnets will be created"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "List of CIDR blocks for the public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "List of CIDR blocks for the private subnets"
}

variable "availability_zones" {
  type = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
  description = "List of availability zones for the subnets"
}


variable "environment" {
  type = string
  default = "dev"
  description = "deployment environment for tagging purposes"
}