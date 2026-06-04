variable "environment" {
  type = string
  description = "The deployment environment name"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "The ARN of the EKS OIDC Provider"
}

variable "eks_oidc_provider_url" {
  type        = string
  description = "The URL of the EKS OIDC Provider"
}