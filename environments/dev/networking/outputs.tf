output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.networking.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.networking.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.networking.public_subnets
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.networking.nat_gateway_ids
}
