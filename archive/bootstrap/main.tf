terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Purpose     = "Terraform State Management"
      ManagedBy   = "Terraform"
      Environment = "shared"
    }
  }
}

module "terraform_state" {
  source = "../../modules/terraform-state"
  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  tags = var.tags
}

