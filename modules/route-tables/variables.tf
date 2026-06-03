variable "vpc_id" {
  type = string
  description = "id of the vpc"
}

variable "environment" {
  type = string
  description = "deployment environment for tagging purposes"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "list of public subnet ids for route table associations"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "list of private subnet ids for route table associations"
}

variable "nat_gateway_ids" {
  type = list(string)
  description = "ids of the nat gateways for private route table"
}

variable "internet_gateway_id" {
  type = string
  description = "id of the internet gateway for public route table"
}

