output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "The ID of the shared public route table"
}

output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
  description = "List of IDs for the private route tables"
}
