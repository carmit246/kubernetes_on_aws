locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "test1111-tf"
    key = "networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "kubernetes" {
  source = "../../modules/eks-auto"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  node_groups = var.node_groups
  enable_cluster_autoscaler = var.enable_cluster_autoscaler
  enable_cluster_encryption = var.enable_cluster_encryption
  tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"
  environment = var.environment
  aws_region  = var.aws_region
  repositories = var.ecr_repositories
  allow_pull_principals = [module.kubernetes.node_iam_role_arn]
  create_vpc_endpoints = true
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr            = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  enable_kms_encryption = false
  tags = local.common_tags
  depends_on = [module.kubernetes]
}

data "aws_caller_identity" "current" {}
