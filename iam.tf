data "aws_iam_policy_document" "mongodb_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "mongodb_permissions" {
  statement {
    sid    = "S3BackupAccess"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.mongodb_backups.arn,
      "${aws_s3_bucket.mongodb_backups.arn}/*",
    ]
  }

  statement {
    sid    = "EC2Management"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:CreateTags",
      "ec2:TerminateInstances",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SecretmanagerAccess"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      aws_secretsmanager_secret.mongodb_ssh_key.arn,
      aws_secretsmanager_secret.mongodb_admin_password.arn,
      aws_secretsmanager_secret.mongodb_tasks_password.arn,
    ]
  }
}

data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Mongodb instance profile
resource "aws_iam_role" "mongodb" {
  name               = "${var.name_prefix}mongodb-role"
  assume_role_policy = data.aws_iam_policy_document.mongodb_assume_role.json

  tags = {
    Name = "${var.name_prefix}mongodb-role"
  }
}

resource "aws_iam_role_policy" "mongodb" {
  name   = "${var.name_prefix}mongodb-policy"
  role   = aws_iam_role.mongodb.id
  policy = data.aws_iam_policy_document.mongodb_permissions.json
}

resource "aws_iam_instance_profile" "mongodb" {
  name = "${var.name_prefix}mongodb-profile"
  role = aws_iam_role.mongodb.name
}

# EKS cluster role
resource "aws_iam_role" "eks_cluster" {
  name               = "${var.name_prefix}eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name = "${var.name_prefix}eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS node pool nodes
resource "aws_iam_role" "eks_nodes" {
  name               = "${var.name_prefix}eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = {
    Name = "${var.name_prefix}eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_read_only" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}