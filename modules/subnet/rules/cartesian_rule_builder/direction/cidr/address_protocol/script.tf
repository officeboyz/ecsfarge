variable "egress" {
  type = bool
}
variable "nacl_id" {
  type = string
}
variable "cidrs" {
  type = object({
    ipv4_cidr = string
    ipv6_cidr = string
  })
}
variable "protocol" {
  type = string
}
variable "port_number" {
  type = number
}

# This is effectively a bitmask where the previous stages mark the bits forming the number based on how many values they are iterating over.
variable "offset" {
  type = number
}
variable "consumed_bits" {
  type = number
}

variable "ipv4" { type = bool}
variable "ipv6" { type = bool}

resource "aws_network_acl_rule" "ipv4" {
  count = var.ipv4 ? 1 : 0
  network_acl_id = var.nacl_id
  rule_number    = var.offset + pow(2, var.consumed_bits)
  egress         = var.egress
  protocol       = var.protocol
  rule_action    = "allow"
  cidr_block     = var.cidrs.ipv4_cidr
  from_port      = var.port_number
  to_port        = var.port_number
}
resource "aws_network_acl_rule" "ipv6" {
  count = var.ipv6 ? 1 : 0
  network_acl_id = var.nacl_id
  rule_number    = var.offset + pow(2, var.consumed_bits + 1)
  egress         = var.egress
  protocol       = var.protocol
  rule_action    = "allow"
  ipv6_cidr_block= var.cidrs.ipv6_cidr
  from_port      = var.port_number
  to_port        = var.port_number
}

