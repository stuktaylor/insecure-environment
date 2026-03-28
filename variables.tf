variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "eu-west-2"
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
  default     = "insecure-environment-"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the first private subnet (AZ a)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the second private subnet (AZ b)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "Availability zone within the AWS region"
  type        = string
  default     = "eu-west-2a"
}

variable mongodb_instance_type {
  description = "EC2 instance type for the MongoDB server"
  type        = string
  default     = "t3.medium"
}

variable mongodb_private_ip {
  description = "EC2 instance static IP"
  type        = string
  default     = "10.0.1.5"
}

variable "backup_cron_schedule" {
  description = "Cron schedule for nightly MongoDB backups (default: 2am)"
  type        = string
  default     = "0 2 * * *"
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.35"
}

variable "eks_node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "eks_admin_principal" {
  description = "IAM Principal with access entry (set by aws sts get-caller-identity)"
  type        = string
  default     = "arn:aws:iam::548932260189:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_525465901663e257"
}


