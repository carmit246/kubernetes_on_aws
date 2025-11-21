data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "test1111-tf"
    key = "kubernetes/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    
    exec  = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
  }
}

module "argocd" {
  source = "../../modules/argocd"
  enable_backend_app = var.enable_backend_app
  backend_app_repo = var.backend_app_repo
  backend_app_path = var.backend_app_path
  backend_app_namespace = var.backend_app_namespace
}


