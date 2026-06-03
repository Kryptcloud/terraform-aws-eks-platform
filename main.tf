#Network infrastructure for EKS cluster


module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}


module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment = var.environment
}



module "internet_gateway" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
  environment = var.environment
}


module "nat_gateway" {
  source = "./modules/nat"
  public_subnet_ids = module.public_subnet_ids
  environment = var.environment

}


module "route_tables" {
  source = "./modules/route-tables"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.public_subnet_ids
  private_subnet_ids = module.private_subnet_ids
  internet_gateway_id = module.internet_gateway.igw_id
  nat_gateway_id = module.nat_gateway.nat_id
  environment = var.environment
}


#Security group for EKS cluster

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  environment = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
}


#IAM roles for EKS cluster and worker nodes
module "iam" {
  source = "./modules/iam"
  environment = var.environment
}


#EKS cluster
module "eks" {
  source = "./modules/eks"
  environment = var.environment
  cluster_role_arn = module.iam.eks_cluster_role_arn
  private_subnet_ids = module.subnets.private_subnet_ids
}



#EKS worker nodes
module "nodegroup" {
  source = "./modules/nodegroup"
  environment = var.environment
  cluster_name = module.eks.cluster_name
  node_role_arn = module.iam.eks_node_role_arn
  private_subnet_ids = module.subnets.private_subnet_ids
  instance_types = var.instance_types
}



#ECR repository
module "ecr" {
  source = "./modules/ecr"
  environment = var.environment
  ecr_name = var.ecr_name
}
