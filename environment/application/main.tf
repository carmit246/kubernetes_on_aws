data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "test1111-tf"
    key = "kubernetes/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "argocd" {
  backend = "s3"
  config = {
    bucket = "test1111-tf"
    key = "argocd/terraform.tfstate"
    region = "eu-west-1"
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

module "application" {
  source = "../../modules/application"
  argocd_namespace = data.terraform_remote_state.argocd.outputs.argocd_namespace
  backend_app_repo = var.backend_app_repo
  backend_app_path = var.backend_app_path
  backend_app_namespace = var.backend_app_namespace
}
