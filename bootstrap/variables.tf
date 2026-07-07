variable "aws_region" {
  description = "AWS region to deploy bootstrap resources"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket that stores Terraform remote state for all labs"
  type        = string
}

variable "github_org" {
  description = "GitHub username or organisation that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without the owner prefix)"
  type        = string
}