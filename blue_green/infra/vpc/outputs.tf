output "public_subnets" {
  value = aws_subnet.public.*.id
  description = "List of public subnet IDs"
}

output "private_subnets" {
  value = aws_subnet.private.*.id
  description = "List of public subnet IDs"
}

output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
  description = "List of private route table IDs"
}