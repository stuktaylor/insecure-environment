resource "aws_ecr_repository" "tasky" {
  name                 = "${var.name_prefix}tasky"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "${var.name_prefix}tasky"
  }
}
