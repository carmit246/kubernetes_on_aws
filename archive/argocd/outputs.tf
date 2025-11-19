output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = module.argocd.argocd_namespace
}

output "argocd_admin_password" {
  description = "ArgoCD initial admin password (base64 encoded)"
  value       = module.argocd.argocd_admin_password
  sensitive   = true
}

output "argocd_admin_password_decoded" {
  description = "ArgoCD initial admin password (decoded)"
  value       = module.argocd.argocd_admin_password_decoded
  sensitive   = true
}

output "argocd_server_url" {
  description = "ArgoCD server URL"
  value = module.argocd.argocd_server_url
}

output "argocd_server_loadbalancer_hostname" {
  description = "ArgoCD server LoadBalancer hostname (if enabled)"
  value       = module.argocd.argocd_server_loadbalancer_hostname
}

output "argocd_port_forward_command" {
  description = "Command to access ArgoCD via port-forward"
  value       = module.argocd.argocd_port_forward_command
}

output "argocd_cli_login_command" {
  description = "Command to login to ArgoCD CLI"
  value = module.argocd.argocd_cli_login_command
}
