variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the cluster"
  type        = list(string)
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
      labels          = {}
      taints          = []
      tags            = {}
    }
  }
}

variable "additional_security_group_rules" {
  description = "Additional security group rules to add to the node security group"
  type        = any
  default     = {}
}

variable "enable_cluster_encryption" {
  description = "Enable encryption for Kubernetes secrets using KMS"
  type        = bool
  default     = false
}

variable "enable_cluster_autoscaler" {
  description = "Enable IAM policy for cluster autoscaler"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

