# ─── SSH Access ───────────────────────────────────────────────────────────────

output "ssh_private_key" {
  description = "Private SSH key for the MongoDB instance. Save with: terraform output -raw ssh_private_key > mongodb.pem && chmod 600 mongodb.pem"
  value       = tls_private_key.mongodb_ssh.private_key_pem
  sensitive   = true
}

output "ssh_connection_string" {
  description = "SSH command to connect to the MongoDB instance"
  value       = "ssh -i mongodb.pem admin@${aws_instance.mongodb.public_ip}"
}

# ─── MongoDB EC2 ──────────────────────────────────────────────────────────────

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

# ─── Networking ───────────────────────────────────────────────────────────────

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

# ─── EKS ──────────────────────────────────────────────────────────────────────

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "API server endpoint for the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_ca_certificate" {
  description = "Base64-encoded CA certificate for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "kubeconfig_command" {
  description = "Command to configure kubectl for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

# ─── S3 ───────────────────────────────────────────────────────────────────────

output "s3_backup_bucket_name" {
  description = "Name of the S3 bucket used for MongoDB backups"
  value       = aws_s3_bucket.mongodb_backups.bucket
}

output "s3_backup_bucket_url" {
  description = "Public URL of the S3 backup bucket"
  value       = "https://${aws_s3_bucket.mongodb_backups.bucket}.s3.${var.aws_region}.amazonaws.com/"
}
