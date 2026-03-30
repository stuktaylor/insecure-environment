# Security group for the MongoDB EC2 instance
resource "aws_security_group" "mongodb" {
  name        = "${var.name_prefix}mongodb-sg"
  description = "Allow SSH from internet and MongoDB from private subnet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MongoDB from private subnet (EKS nodes)"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}mongodb-sg"
  }
}

# Security group for EKS 
resource "aws_security_group" "eks_cluster" {
  name        = "${var.name_prefix}eks-cluster-sg"
  description = "EKS control plane security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "API server from worker nodes"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}eks-cluster-sg"
  }
}

# Security group for EKS worker nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.name_prefix}eks-nodes-sg"
  description = "EKS worker node security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Control plane to node communication"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    description = "Node to node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}eks-nodes-sg"
  }
}
