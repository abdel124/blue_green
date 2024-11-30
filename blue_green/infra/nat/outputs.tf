output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat.*.id
  description = "List of NAT Gateway IDs"
}
