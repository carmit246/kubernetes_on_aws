variable "enable_backend_app" {
  description = "Enable backend application deployment via ArgoCD"
  type        = bool
  default     = false
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for argocd"
  type        = string
  default     = "argocd"
}

variable "backend_app_repo" {
  description = "Git repository URL for the backend application"
  type        = string
  default     = ""
}

variable "backend_app_branch" {
  description = "Git branch for the backend application"
  type        = string
  default     = "main"
}

variable "backend_app_path" {
  description = "Path in the Git repository containing Kubernetes manifests"
  type        = string
  default     = "backend"
}

variable "backend_app_namespace" {
  description = "Kubernetes namespace for the backend application"
  type        = string
  default     = "backend"
}