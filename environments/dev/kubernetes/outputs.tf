output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = module.kubernetes.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.kubernetes.cluster_arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.kubernetes.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.kubernetes.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.kubernetes.cluster_security_group_id
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = module.kubernetes.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.kubernetes.cluster_certificate_authority_data
  sensitive   = true
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = module.kubernetes.node_security_group_id
}

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.kubernetes.eks_managed_node_groups
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for EKS"
  value       = module.kubernetes.oidc_provider_arn
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider"
  value       = module.kubernetes.oidc_provider
}

output "cluster_autoscaler_iam_policy_arn" {
  description = "ARN of IAM policy for cluster autoscaler"
  value       = module.kubernetes.cluster_autoscaler_iam_policy_arn
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.kubernetes.cluster_name}"
}

output "node_iam_role_arn" {
  value = module.kubernetes.node_iam_role_arn
}

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "ecr_repository_urls" {
  description = "Map of ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "Map of ECR repository ARNs"
  value       = module.ecr.repository_arns
}