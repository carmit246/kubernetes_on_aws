output "repository_urls" {
  description = "Map of repository names to their URLs"
  value = {
    for k, repo in aws_ecr_repository.repositories : k => repo.repository_url
  }
}

output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value = {
    for k, repo in aws_ecr_repository.repositories : k => repo.arn
  }
}

output "repository_names" {
  description = "List of repository names"
  value       = [for repo in aws_ecr_repository.repositories : repo.name]
}

output "repository_registry_ids" {
  description = "Map of repository names to their registry IDs"
  value = {
    for k, repo in aws_ecr_repository.repositories : k => repo.registry_id
  }
}

output "ecr_api_endpoint_id" {
  description = "ID of the ECR API VPC endpoint"
  value       = try(aws_vpc_endpoint.ecr_api[0].id, null)
}

output "ecr_dkr_endpoint_id" {
  description = "ID of the ECR Docker VPC endpoint"
  value       = try(aws_vpc_endpoint.ecr_dkr[0].id, null)
}

output "vpc_endpoint_security_group_id" {
  description = "Security group ID for ECR VPC endpoints"
  value       = try(aws_security_group.vpc_endpoints[0].id, null)
}

output "docker_login_command" {
  description = "Command to authenticate Docker with ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${try(values(aws_ecr_repository.repositories)[0].registry_id, "YOUR_ACCOUNT_ID")}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "example_push_commands" {
  description = "Example commands to build and push images"
  value = {
    for k, repo in aws_ecr_repository.repositories : k => {
      build = "docker build -t ${repo.name} ."
      tag   = "docker tag ${repo.name}:latest ${repo.repository_url}:latest"
      push  = "docker push ${repo.repository_url}:latest"
    }
  }
}

