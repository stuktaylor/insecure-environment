output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state — copy this into backend.tfvars"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking — copy this into backend.tfvars"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions OIDC — set as AWS_ROLE_ARN in the repo's Actions secrets/variables"
  value       = aws_iam_role.github_actions.arn
}
