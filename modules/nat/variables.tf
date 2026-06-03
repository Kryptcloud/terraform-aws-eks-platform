variable "public_subnet_ids" {
  type = list(string)
  description = "list of public subnet ids to host the NAT gateway"
}

variable "environment" {
  type = string
  description = "deployment environment name"
}
