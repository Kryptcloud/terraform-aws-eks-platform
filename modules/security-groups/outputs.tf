output "security_group_ids" {
  description = "IDs of all created security groups"
  value       = [aws_security_group.alb.id, aws_security_group.app.id]
}

output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security group ID for the application instances"
  value       = aws_security_group.app.id
}