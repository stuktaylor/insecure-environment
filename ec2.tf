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

locals {

  # Add backup script to local variabl so it grabs bucket name and region 
  # before passing to the instance userdata

  backup_script = templatefile("${path.module}/templates/mongodb_backup.sh.tpl",
 {
    bucket_name = aws_s3_bucket.mongodb_backups.bucket
    aws_region  = var.aws_region
  })
}

resource "aws_key_pair" "mongodb" {
  key_name   = "${var.name_prefix}mongodb-key"
  public_key = var.ec2_public_key

  tags = {
    Name = "${var.name_prefix}mongodb-key"
  }
}

# Use a static internal IP ENI
resource "aws_network_interface" "mongo_eni" {
  subnet_id = aws_subnet.public.id
  private_ips = [var.mongodb_private_ip] 
  security_groups = [aws_security_group.mongodb.id]

  tags = {
    Name = "${var.name_prefix}mongodb-eni"
  }
}

resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.mongodb_instance_type
  iam_instance_profile   = aws_iam_instance_profile.mongodb.name
  key_name               = aws_key_pair.mongodb.key_name

  user_data = templatefile("${path.module}/templates/mongodb_userdata.sh.tpl", {
    backup_script        = local.backup_script
    backup_cron_schedule = var.backup_cron_schedule
  })

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}mongodb"
  }
}

resource "aws_network_interface_attachment" "mongodb_eni_attachment" {
  instance_id           = aws_instance.mongodb.id
  network_interface_id  = aws_network_interface.mongo_eni.id
  device_index          = 0
}
