module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.name_prefix}eks"
  cluster_version = var.eks_kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Reuse security groups defined in security_groups.tf
  create_cluster_security_group = false
  cluster_security_group_id     = aws_security_group.eks_cluster.id
  create_node_security_group    = false
  node_security_group_id        = aws_security_group.eks_nodes.id

  cluster_addons = {
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    main = {
      name           = "eks-nodes"
      instance_types = [var.eks_node_instance_type]
      min_size       = var.eks_node_min_size
      max_size       = var.eks_node_max_size
      desired_size   = var.eks_node_desired_size
    }
  }

  access_entries = {
    eks-admin = {
      principal_arn = var.eks_admin_principal
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
    github-actions = {
      principal_arn = var.deployment_principal
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  tags = { Name = "${var.name_prefix}eks" }
}
