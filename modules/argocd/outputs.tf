output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_admin_password" {
  description = "ArgoCD initial admin password (base64 encoded)"
  value       = try(data.kubernetes_secret.argocd_admin.data["password"], null)
  sensitive   = true
}

output "argocd_admin_password_decoded" {
  description = "ArgoCD initial admin password (decoded)"
  value       = try(base64decode(data.kubernetes_secret.argocd_admin.data["password"]), null)
  sensitive   = true
}

output "argocd_server_url" {
  description = "ArgoCD server URL"
  value = var.argocd_enable_loadbalancer ? "https://${try(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname, "<pending>")}" : "Use port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"
}

output "argocd_server_loadbalancer_hostname" {
  description = "ArgoCD server LoadBalancer hostname (if enabled)"
  value       = var.argocd_enable_loadbalancer ? try(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname, null) : null
}

output "argocd_port_forward_command" {
  description = "Command to access ArgoCD via port-forward"
  value       = "kubectl port-forward svc/argocd-server -n argocd 8080:443" 
}

output "argocd_cli_login_command" {
  description = "Command to login to ArgoCD CLI"
  value = var.argocd_enable_loadbalancer ? "argocd login ${try(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname, "<pending>")}" : "argocd login localhost:8080 --insecure"
}

output "argocd_ha_enabled" {
  description = "Whether ArgoCD is deployed in HA mode"
  value       = var.argocd_ha_enabled
}

output "argocd_metrics_enabled" {
  description = "Whether ArgoCD metrics are enabled"
  value       =  var.argocd_metrics_enabled
}

