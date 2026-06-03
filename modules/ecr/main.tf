resource "aws_ecr_repository" "krypt" {
  name                 = "${var.environment}-${var.ecr_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-${var.ecr_name}"
    Environment = var.environment
  }
}
