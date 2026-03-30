module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}vpc"
  cidr = var.vpc_cidr

  azs             = [var.availability_zone, "eu-west-2b"]
  public_subnets  = [var.public_subnet_cidr]
  private_subnets = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
