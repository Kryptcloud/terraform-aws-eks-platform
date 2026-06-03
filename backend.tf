terraform {
  backend "s3" {
    bucket       = "kryptcloud-terraform-state-bucket"
    key          = "platform/dev/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}