data "aws_ami" "amazon_linux" {
  most_recent = true
  include_deprecated = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "creation-date"
    values = ["2024-*"]
  }
}

resource "tls_private_key" "mongodb_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mongodb" {
  key_name   = "${var.name_prefix}mongodb-key"
  public_key = tls_private_key.mongodb_ssh.public_key_openssh

  tags = {
    Name = "${var.name_prefix}mongodb-key"
  }
}

resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.mongodb_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  iam_instance_profile   = aws_iam_instance_profile.mongodb.name
  key_name               = aws_key_pair.mongodb.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}mongodb"
  }
}
