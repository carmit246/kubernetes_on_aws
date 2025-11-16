variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state storage"
  type        = string
  default     = "test1111-tf"
}

variable "enable_logging" {
  description = "Enable S3 bucket logging"
  type        = bool
  default     = false
}

variable "logging_bucket_name" {
  description = "Name of the S3 bucket for logging (if different from state bucket)"
  type        = string
  default     = null
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "test1-tf"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

