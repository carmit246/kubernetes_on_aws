variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.51.0"  # Stable version
}

variable "argocd_version" {
  description = "ArgoCD application version (image tag)"
  type        = string
  default     = "v2.9.3"  # Stable version
}

variable "argocd_ha_enabled" {
  description = "Enable high availability mode (multiple replicas)"
  type        = bool
  default     = false
}

variable "argocd_enable_loadbalancer" {
  description = "Expose ArgoCD server via LoadBalancer"
  type        = bool
  default     = false
}

variable "argocd_loadbalancer_internal" {
  description = "Create internal LoadBalancer (if argocd_enable_loadbalancer is true)"
  type        = bool
  default     = false
}

variable "argocd_metrics_enabled" {
  description = "Enable Prometheus metrics for ArgoCD"
  type        = bool
  default     = false
}