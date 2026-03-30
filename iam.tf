data "aws_iam_policy_document" "mongodb_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


# MongoDB instance profile
resource "aws_iam_role" "mongodb" {
  name               = "${var.name_prefix}mongodb-role"
  assume_role_policy = data.aws_iam_policy_document.mongodb_assume_role.json

  tags = {
    Name = "${var.name_prefix}mongodb-role"
  }
}

resource "aws_iam_role_policy" "mongodb" {
  name = "${var.name_prefix}mongodb-policy"
  role = aws_iam_role.mongodb.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BackupAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Resource = [
          module.s3_backup.s3_bucket_arn,
          "${module.s3_backup.s3_bucket_arn}/*",
        ]
      },
      {
        Sid    = "EC2Management"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
        ]
        Resource = ["*"]
      },
      {
        Sid    = "SecretmanagerAccess"
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = [
          aws_secretsmanager_secret.mongodb_ssh_key.arn,
          aws_secretsmanager_secret.mongodb_admin_password.arn,
          aws_secretsmanager_secret.mongodb_tasks_password.arn,
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "mongodb" {
  name = "${var.name_prefix}mongodb-profile"
  role = aws_iam_role.mongodb.name
}

# AWS Load Balancer Controller IRSA
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "lbc" {
  name   = "${var.name_prefix}aws-load-balancer-controller"
  policy = data.http.lbc_iam_policy.response_body
}

resource "aws_iam_role" "lbc" {
  name = "${var.name_prefix}aws-load-balancer-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lbc" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc.arn
}
