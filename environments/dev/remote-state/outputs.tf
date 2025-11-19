output "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = module.terraform_state.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.terraform_state.s3_bucket_arn
}

output "s3_bucket_region" {
  description = "Region of the S3 bucket"
  value       = module.terraform_state.s3_bucket_region
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = module.terraform_state.dynamodb_table_id
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.terraform_state.dynamodb_table_arn
}

