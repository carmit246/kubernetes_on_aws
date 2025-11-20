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

variable "enable_argocd" {
  description = "Enable ArgoCD deployment to the cluster"
  type        = bool
  default     = false
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
variable "enable_backend_app" {
  description = "Enable backend application deployment via ArgoCD"
  type        = bool
  default     = true
}

variable "backend_app_repo" {
  description = "Git repository URL for the backend application"
  type        = string
  default     = "https://github.com/carmit246/fastapi-helloworld.git"
}

variable "backend_app_branch" {
  description = "Git branch for the backend application"
  type        = string
  default     = "main"
}

variable "backend_app_path" {
  description = "Path in the Git repository containing Kubernetes manifests"
  type        = string
  default     = "helm/helloworld"
}

variable "backend_app_namespace" {
  description = "Kubernetes namespace for the backend application"
  type        = string
  default     = "backend-app"
}