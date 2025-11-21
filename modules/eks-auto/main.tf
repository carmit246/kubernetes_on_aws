module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = merge(
    var.tags,
    {
      Module = "kubernetes"
    }
  )
}

module "disabled_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  create = false
}