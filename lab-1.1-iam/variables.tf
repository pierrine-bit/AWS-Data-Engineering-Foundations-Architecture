variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "Region must be one of: us-east-1, us-west-2, eu-west-1."
  }
}

variable "environment" {
  description = "Deployment environment — controls resource tagging and naming"
  type        = string
  default     = "sandbox"

  validation {
    condition     = contains(["dev", "staging", "prod", "sandbox"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, sandbox."
  }
}

variable "data_engineer_policies" {
  description = "Managed policy ARNs attached to DataEngineerRole — grants access to S3, Glue, Redshift, EMR, Kinesis, Lambda, and CloudWatch"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSGlueFullAccess",
    "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess",
    "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2",
    "arn:aws:iam::aws:policy/AmazonKinesisFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

variable "glue_policies" {
  description = "Managed policy ARNs attached to GlueServiceRole — grants Glue ETL jobs access to S3, CloudWatch, and Secrets Manager"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

variable "lambda_policies" {
  description = "Managed policy ARNs attached to LambdaExecutionRole — grants Lambda functions access to S3, DynamoDB, Kinesis, and Secrets Manager"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonKinesisFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

variable "redshift_policies" {
  description = "Managed policy ARNs attached to RedshiftIAMRole — grants Redshift access to S3 for COPY commands and CloudWatch for logging"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

variable "analyst_policies" {
  description = "Managed policy ARNs attached to AnalystReadOnlyRole — read-only access to Athena, Redshift, QuickSight, and S3"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/AmazonRedshiftReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonQuickSightReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}
