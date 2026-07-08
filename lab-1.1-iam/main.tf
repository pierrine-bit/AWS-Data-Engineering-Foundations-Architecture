terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Using local state — DCE environment does not permit S3 bucket creation
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = "DataPlatform"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = "1.1-IAM"
    Owner       = "CDEM01"
  }
}

resource "aws_iam_policy" "data_lake_access" {
  name        = "DataLakeBucketAccessPolicy"
  description = "Custom policy to access data-lake-* S3 buckets with encryption enforcement"

  policy = file("${path.module}/policies/data-lake-bucket-access.json")

  tags = local.common_tags
}

module "data_engineer_role" {
  source = "./modules/iam-role"

  role_name        = "DataEngineerRole"
  trusted_services = ["ec2.amazonaws.com"]
  description      = "Role for data engineers to access S3, Glue, Redshift, EMR, Kinesis, Lambda, and CloudWatch"
  policy_arns      = var.data_engineer_policies
  tags             = local.common_tags
}

module "glue_service_role" {
  source = "./modules/iam-role"

  role_name        = "GlueServiceRole"
  trusted_services = ["glue.amazonaws.com"]
  description      = "Used by AWS Glue jobs for ETL processing"
  policy_arns      = var.glue_policies
  tags             = local.common_tags
}

module "lambda_execution_role" {
  source = "./modules/iam-role"

  role_name        = "LambdaExecutionRole"
  trusted_services = ["lambda.amazonaws.com"]
  description      = "Used by Lambda functions for serverless data processing"
  policy_arns      = var.lambda_policies
  tags             = local.common_tags
}

module "redshift_iam_role" {
  source = "./modules/iam-role"

  role_name        = "RedshiftIAMRole"
  trusted_services = ["redshift.amazonaws.com"]
  description      = "Allows Redshift to access S3 for COPY commands"
  policy_arns      = var.redshift_policies
  tags             = local.common_tags
}

module "analyst_readonly_role" {
  source = "./modules/iam-role"

  role_name        = "AnalystReadOnlyRole"
  trusted_services = ["ec2.amazonaws.com"]
  description      = "Read-only access for analysts via Athena, Redshift, QuickSight, and S3"
  policy_arns      = var.analyst_policies
  tags             = local.common_tags
}
