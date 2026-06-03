#Allocate elastic IP for NAT gateway

resource "aws_eip" "nat" {
  count = length(var.public_subnet_ids)
  domain   = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
  }
}


#Create NAT gateway in each public subnet

resource "aws_nat_gateway" "public" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags = {
    Name        = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
  }
}