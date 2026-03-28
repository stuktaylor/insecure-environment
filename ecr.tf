resource "aws_ecr_repository" "tasky" {
  name                 = "tasky"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
   
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "tasky"
  }
}
