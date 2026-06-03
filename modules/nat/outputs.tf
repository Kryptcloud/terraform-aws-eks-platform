output "nat_gateway_ids" {
  value = aws_nat_gateway.public[*].id
  description = "List of NAT gateway IDs created in the public subnets"
}