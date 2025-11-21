variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name to be used as a prefix for resources"
  type        = string
  default     = "test1"
}

variable "create_vpc_endpoints" {
  description = "Enable ECR VPC endpoints (costs ~$7/month but saves data transfer)"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test1-eks"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to cluster endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to cluster endpoint"
  type        = bool
  default     = true
}

variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    instance_types   = list(string)
    capacity_type    = string
    min_size         = number
    max_size         = number
    desired_size     = number
    disk_size        = number
    disk_type        = string
    disk_iops        = optional(number, 3000)
    disk_throughput  = optional(number, 125)
    labels           = optional(map(string), {})
    taints           = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    tags             = optional(map(string), {})
  }))
  default = {
    backend = {
      instance_types  = ["t3.medium", "t3a.medium"]
      capacity_type   = "SPOT"
      min_size        = 1
      max_size        = 3
      desired_size    = 2
      disk_size       = 50
      disk_type       = "gp3"
      disk_iops       = 3000
      disk_throughput = 125
      labels = {
        role = "backend"
      }
      taints = []
      tags   = {}
    }
  }
}

variable "enable_cluster_autoscaler" {
  description = "Enable cluster autoscaler IAM policies"
  type        = bool
  default     = true
}

variable "enable_cluster_encryption" {
  description = "Enable encryption for Kubernetes secrets using KMS"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_kms_encryption" {
  description = "Enable encryption using KMS"
  type        = bool
  default     = false
}


variable "ecr_repositories" {
  description = "Map of ECR repository configurations"
  type = map(object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    max_image_count      = optional(number, 10)
    tags                 = optional(map(string), {})
  }))
  
  default = {
    backend = {
      name                 = "test1-app"
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      max_image_count      = 10
      tags                 = {}
    }
  }
}