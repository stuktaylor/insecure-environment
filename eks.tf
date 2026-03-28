resource "aws_eks_cluster" "main" {
  name     = "${var.name_prefix}eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_kubernetes_version

  vpc_config {
    subnet_ids              = [aws_subnet.private.id]
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # Cluster role must be ready before the cluster is created
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]

  tags = {
    Name = "${var.name_prefix}eks"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.name_prefix}eks-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [aws_subnet.private.id]
  instance_types  = [var.eks_node_instance_type]

  scaling_config {
    desired_size = var.eks_node_desired_size
    min_size     = var.eks_node_min_size
    max_size     = var.eks_node_max_size
  }

  # Node role policies must be attached before nodes are created
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_read_only,
  ]

  tags = {
    Name = "${var.name_prefix}eks-nodes"
  }
}
