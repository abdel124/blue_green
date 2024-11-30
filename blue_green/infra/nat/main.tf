resource "aws_eip" "nat" {
  count = length(var.public_subnets)
  vpc   = true

  tags = merge(var.tags, {
    Name = "NAT Gateway EIP ${count.index}"
  })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnets[count.index]

  tags = merge(var.tags, {
    Name = "NAT Gateway ${count.index}"
  })
}

resource "aws_route" "private_to_nat" {
  count                   = var.enable_nat_gateway ? length(var.private_subnets) : 0
  route_table_id          = var.private_route_table_ids[count.index]
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat[0].id
}