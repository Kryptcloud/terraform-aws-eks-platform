#create the public subnets
resource "aws_subnet" "public" { 
  count = length(var.public_subnet_cidrs)

    vpc_id =var.vpc_id
    cidr_block =var.public_subnet_cidrs[count.index]
    availability_zone =var.availability_zones[count.index]


    tags = {
        name =                               "${var.environment}--public-subnet-${count.index + 1}"
        environment =                        var.environment
        "kubernetes.io/role/internal-elb" =              "1"
        "kubernetes.io/cluster/${var.environment}--eks" = "shared"
    
    }
}

#create the private subnets
resource "aws_subnet" "private" { 
  count = length(var.private_subnet_cidrs)

    vpc_id =var.vpc_id
    cidr_block =var.private_subnet_cidrs[count.index]
    availability_zone =var.availability_zones[count.index]

    tags = {
        name =                               "${var.environment}--private-subnet-${count.index + 1}"
        environment =                        var.environment
        "kubernetes.io/role/node" =             "1"
        "kubernetes.io/cluster/${var.environment}--eks" = "shared"
    }
}