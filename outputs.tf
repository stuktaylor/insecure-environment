
# Mongo outputs

output "mongodb_public_ip" {
  description = "Public IP address of the MongoDB EC2 instance"
  value       = aws_instance.mongodb.public_ip
}

output "mongodb_private_ip" {
  description = "Private IP address of the MongoDB EC2 instance"
  value       = aws_instance.mongodb.private_ip
}

output "mongodb_instance_id" {
  description = "Instance ID of the MongoDB EC2 instance"
  value       = aws_instance.mongodb.id
}

# Network outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

# SSH key outputs

output "mongodb_ssh_key_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the MongoDB SSH private key"
  value       = aws_secretsmanager_secret.mongodb_ssh_key.arn
}

# S3 outputs

output "s3_backup_bucket_name" {
  description = "Name of the S3 bucket used for MongoDB backups"
  value       = aws_s3_bucket.mongodb_backups.bucket
}

output "s3_backup_bucket_url" {
  description = "Public URL of the S3 backup bucket"
  value       = "https://${aws_s3_bucket.mongodb_backups.bucket}.s3.${var.aws_region}.amazonaws.com/"
}
