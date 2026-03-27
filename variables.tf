variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "eu-west-2"
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
  default     = "insecure-environment"
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

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
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

variable "ec2_public_key" {
  description = "Picked up from the Github Actions pipeline"
  type        = string
}

variable "backup_cron_schedule" {
  description = "Cron schedule for nightly MongoDB backups (default: 2am)"
  type        = string
  default     = "0 2 * * *"
}