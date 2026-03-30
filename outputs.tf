output "mongodb_public_ip" {
  description = "Public IP address of the MongoDB EC2 instance"
  value       = aws_eip.mongodb.public_ip
}

output "mongodb_private_ip" {
  description = "Private IP address of the MongoDB EC2 instance"
  value       = aws_instance.mongodb.private_ip
}

output "mongodb_instance_id" {
  description = "Instance ID of the MongoDB EC2 instance"
  value       = aws_instance.mongodb.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnets[0]
}

output "private_subnet_id_a" {
  description = "ID of the private subnet a"
  value       = module.vpc.private_subnets[0]
}

output "private_subnet_id_b" {
  description = "ID of the private subnet b"
  value       = module.vpc.private_subnets[1]
}

output "mongodb_ssh_key_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the MongoDB SSH private key"
  value       = aws_secretsmanager_secret.mongodb_ssh_key.arn
}

output "mongodb_admin_password_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the MongoDB admin password"
  value       = aws_secretsmanager_secret.mongodb_admin_password.arn
}

output "mongodb_tasks_password_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the MongoDB tasks user password"
  value       = aws_secretsmanager_secret.mongodb_tasks_password.arn
}

output "s3_backup_bucket_name" {
  description = "Name of the S3 bucket used for MongoDB backups"
  value       = module.s3_backup.s3_bucket_id
}

output "s3_backup_bucket_url" {
  description = "Public URL of the S3 backup bucket"
  value       = "https://${module.s3_backup.s3_bucket_id}.s3.${var.aws_region}.amazonaws.com/"
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API server endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "Base64-encoded CA certificate for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "ecr_repository_url" {
  description = "URL of the tasky ECR repository"
  value       = aws_ecr_repository.tasky.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the tasky ECR repository"
  value       = aws_ecr_repository.tasky.arn
}
