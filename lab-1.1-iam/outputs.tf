output "data_engineer_role_arn" {
  description = "ARN of the DataEngineerRole"
  value       = module.data_engineer_role.role_arn
}

output "glue_service_role_arn" {
  description = "ARN of the GlueServiceRole"
  value       = module.glue_service_role.role_arn
}

output "lambda_execution_role_arn" {
  description = "ARN of the LambdaExecutionRole"
  value       = module.lambda_execution_role.role_arn
}

output "redshift_iam_role_arn" {
  description = "ARN of the RedshiftIAMRole"
  value       = module.redshift_iam_role.role_arn
}

output "analyst_readonly_role_arn" {
  description = "ARN of the AnalystReadOnlyRole"
  value       = module.analyst_readonly_role.role_arn
}

output "data_lake_policy_arn" {
  description = "ARN of the custom DataLakeBucketAccessPolicy"
  value       = aws_iam_policy.data_lake_access.arn
}

