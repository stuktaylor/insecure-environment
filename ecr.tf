resource "aws_ecr_repository" "tasky" {
  name                 = "tasky"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "tasky"
  }
}
