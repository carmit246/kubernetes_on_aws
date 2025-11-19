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

module "networking" {
  source = "./modules/networking"
  vpc_name                 = "${var.project_name}-${var.environment}-vpc"
  vpc_cidr                 = var.vpc_cidr
  aws_region               = var.aws_region
  availability_zones_count = var.availability_zones_count
  single_nat_gateway       = var.single_nat_gateway
  cluster_name             = var.cluster_name
  tags = local.common_tags
}

module "kubernetes" {
  source = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnets
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  node_groups = var.node_groups
  enable_cluster_autoscaler = var.enable_cluster_autoscaler
  enable_cluster_encryption = var.enable_cluster_encryption
  tags = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"
  environment = var.environment
  aws_region  = var.aws_region
  repositories = var.ecr_repositories
  allow_pull_principals = [module.kubernetes.node_iam_role_arn]
  create_vpc_endpoints = true
  vpc_id              = module.networking.vpc_id
  vpc_cidr            = var.vpc_cidr
  private_subnet_ids  = module.networking.private_subnets
  enable_kms_encryption = false
  tags = local.common_tags
  depends_on = [module.kubernetes]
}

data "aws_caller_identity" "current" {}

