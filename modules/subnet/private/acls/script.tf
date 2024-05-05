variable "nacl_id" { type = string }

variable "subnet_blocks" {
  type = object({
    public = object({
      ipv6 = string
      ipv4 = string
    })
    private = object({
      ipv6 = string
      ipv4 = string
    })
  })
}

locals {
  permitted_protocols = [
    { # app traffic
      protocol    = "tcp"
      port_number = 8080
    },
    { # https
      protocol    = "tcp"
      port_number = 443
    },
  ]
}


module "rules" {
  source = "../../rules/cartesian_rule_builder"
  cidrs  = [{
    ipv4_cidr = var.subnet_blocks.public.ipv4
    ipv6_cidr = var.subnet_blocks.public.ipv6
  }, {
    ipv4_cidr = var.subnet_blocks.private.ipv4
    ipv6_cidr = var.subnet_blocks.private.ipv6
  }]
  nacl_id = var.nacl_id
  protocol_port_pairs = local.permitted_protocols
  ipv4 = true
  ipv6 = true
}

resource "aws_network_acl_rule" "allow_all_outbound_443" {
  egress         = true
  protocol       = "tcp"
  rule_number    = 100
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
  network_acl_id = var.nacl_id
}
resource "aws_network_acl_rule" "allow_all_outbound_443_ipv6" {
  egress         = true
  protocol       = "tcp"
  rule_number    = 101
  rule_action    = "allow"
  ipv6_cidr_block= "::/0"
  from_port      = 443
  to_port        = 443
  network_acl_id = var.nacl_id
}
resource "aws_network_acl_rule" "allow_all_inbound_443" {
  egress         = false
  protocol       = "tcp"
  rule_number    = 100
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
  network_acl_id = var.nacl_id
}
resource "aws_network_acl_rule" "allow_all_inbound_443_ipv6" {
  egress         = false
  protocol       = "tcp"
  rule_number    = 101
  rule_action    = "allow"
  ipv6_cidr_block= "::/0"
  from_port      = 443
  to_port        = 443
  network_acl_id = var.nacl_id
}
