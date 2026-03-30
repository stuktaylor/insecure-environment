resource "random_id" "bucket_suffix" {
  byte_length = 4
}

module "s3_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${var.name_prefix}mongodb-backups-${random_id.bucket_suffix.hex}"

  versioning = { enabled = true }

  # Intentionally insecure — public access required for this environment
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = { Name = "${var.name_prefix}mongodb-backups" }
}

resource "aws_s3_bucket_policy" "mongodb_backups_public" {
  bucket = module.s3_backup.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${module.s3_backup.s3_bucket_arn}/*"
      },
      {
        Sid       = "PublicListBucket"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = module.s3_backup.s3_bucket_arn
      }
    ]
  })

  depends_on = [module.s3_backup]
}
