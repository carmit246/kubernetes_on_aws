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
  source = "../../../modules/networking"
  vpc_name                 = "${var.project_name}-${var.environment}-vpc"
  vpc_cidr                 = var.vpc_cidr
  aws_region               = var.aws_region
  availability_zones_count = var.availability_zones_count
  single_nat_gateway       = var.single_nat_gateway
  tags = local.common_tags
}


