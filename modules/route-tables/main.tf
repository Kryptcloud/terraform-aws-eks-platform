#Create public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.environment}-public"
  }
}


#Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)
  subnet_id = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

#Create private route table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.environment}-private"
  }
}


#Associate private route table with private subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)
  subnet_id = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}