output "subnet_ids" {
  description = "IDs of all created subnets"
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
}

output "subnet_cidr_blocks" {
  description = "CIDR blocks of all created subnets"
  value       = { for key, subnet in aws_subnet.this : key => subnet.cidr_block }
}