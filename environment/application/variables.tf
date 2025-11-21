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