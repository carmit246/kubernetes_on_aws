output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = module.eks.cluster_version
}

output "cluster_platform_version" {
  description = "The platform version for the cluster"
  value       = module.eks.cluster_platform_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for EKS"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = module.eks.node_security_group_id
}

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_autoscaler_iam_policy_arn" {
  description = "ARN of IAM policy for cluster autoscaler"
  value       = var.enable_cluster_autoscaler ? aws_iam_policy.cluster_autoscaler[0].arn : null
}

output "node_iam_role_arn" {
  description = "EKS node IAM role ARN"
  value = module.eks.eks_managed_node_groups["backend"].iam_role_arn
}

output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = module.eks.cluster_addons
}

output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = var.enable_argocd ? kubernetes_namespace.argocd[0].metadata[0].name : null
}

output "argocd_admin_password" {
  description = "ArgoCD initial admin password (base64 encoded)"
  value       = var.enable_argocd ? try(data.kubernetes_secret.argocd_admin[0].data["password"], null) : null
  sensitive   = true
}

output "argocd_admin_password_decoded" {
  description = "ArgoCD initial admin password (decoded)"
  value       = var.enable_argocd ? try(base64decode(data.kubernetes_secret.argocd_admin[0].data["password"]), null) : null
  sensitive   = true
}

output "argocd_server_url" {
  description = "ArgoCD server URL"
  value = var.enable_argocd ? (
    var.argocd_enable_loadbalancer ? 
    "https://${try(data.kubernetes_service.argocd_server[0].status[0].load_balancer[0].ingress[0].hostname, "<pending>")}" :
    "Use port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"
  ) : null
}

output "argocd_server_loadbalancer_hostname" {
  description = "ArgoCD server LoadBalancer hostname (if enabled)"
  value       = var.enable_argocd && var.argocd_enable_loadbalancer ? try(data.kubernetes_service.argocd_server[0].status[0].load_balancer[0].ingress[0].hostname, null) : null
}

output "argocd_port_forward_command" {
  description = "Command to access ArgoCD via port-forward"
  value       = var.enable_argocd ? "kubectl port-forward svc/argocd-server -n argocd 8080:443" : null
}

output "argocd_cli_login_command" {
  description = "Command to login to ArgoCD CLI"
  value = var.enable_argocd ? (
    var.argocd_enable_loadbalancer ?
    "argocd login ${try(data.kubernetes_service.argocd_server[0].status[0].load_balancer[0].ingress[0].hostname, "<pending>")}" :
    "argocd login localhost:8080 --insecure"
  ) : null
}

output "argocd_ha_enabled" {
  description = "Whether ArgoCD is deployed in HA mode"
  value       = var.enable_argocd ? var.argocd_ha_enabled : null
}

output "argocd_metrics_enabled" {
  description = "Whether ArgoCD metrics are enabled"
  value       = var.enable_argocd ? var.argocd_metrics_enabled : null
}

