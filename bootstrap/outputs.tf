output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform remote state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  value       = aws_s3_bucket.tfstate.arn
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC role — add this as AWS_OIDC_ROLE_ARN in GitHub Secrets"
  value       = aws_iam_role.github_actions.arn
}
