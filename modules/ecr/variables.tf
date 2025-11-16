variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "repositories" {
  description = "Map of ECR repository configurations"
  type = map(object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    max_image_count      = optional(number, 10)
    tags                 = optional(map(string), {})
  }))
  
  default = {
    backend = {
      name                 = "backend-app"
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      max_image_count      = 10
      tags                 = {}
    }
  }
}

variable "enable_kms_encryption" {
  description = "Enable KMS encryption for ECR repositories"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN of KMS key for ECR encryption (required if enable_kms_encryption is true)"
  type        = string
  default     = null
}

variable "allow_pull_principals" {
  description = "List of IAM principal ARNs allowed to pull images (e.g., EKS node role ARN)"
  type        = list(string)
  default     = []
}

variable "create_vpc_endpoints" {
  description = "Create VPC endpoints for ECR (cost optimization - avoid NAT Gateway charges)"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where ECR VPC endpoints will be created"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for VPC endpoints"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}