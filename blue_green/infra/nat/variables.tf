variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs where NAT Gateways will be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to NAT Gateway and EIP"
  default     = {}
}

variable "private_route_table_ids" {
  description = "List of private route table IDs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway for private subnets"
  type        = bool
  default     = true
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs where NAT Gateways will be created"
}
