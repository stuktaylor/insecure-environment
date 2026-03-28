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