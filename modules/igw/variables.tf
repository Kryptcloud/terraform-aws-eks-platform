variable "vpc_id" {
  type = string
  description = "ID of the vpc where the igw will be deployed"
}

variable "environment" {
  type = string
  description = "deployment environment for tagging purposes"
}
