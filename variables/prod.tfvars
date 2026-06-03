environment          = "prod"
vpc_cidr             = "10.0.200.0/16"
vpc_name             = "prod-vpc"
public_subnet_cidrs  = ["10.0.201.0/24", "10.0.202.0/24"]
private_subnet_cidrs = ["10.0.203.0/24", "10.0.204.0/24"]
allowed_ssh_cidr    = ["10.0.0.0/0"]
instance_types = ["t3.medium"]
ecr_name = "my-kubernetes-app"
