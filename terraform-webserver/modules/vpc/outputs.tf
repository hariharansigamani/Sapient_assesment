output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.default_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the created public subnets."
  value       = values(aws_subnet.public_subnets)[*].id
}