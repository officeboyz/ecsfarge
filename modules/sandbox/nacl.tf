resource "aws_network_acl" "open_nacl" {
  vpc_id = aws_vpc.sandbox_vpc.id
  tags = {
    Name = "open-nacl-sandbox"
    environment = "sandbox"
  }
}

resource "aws_network_acl_rule" "ingress_allow_all" {
  network_acl_id = aws_network_acl.open_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "egress_allow_all" {
  network_acl_id = aws_network_acl.open_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "subnet_1_association" {
  network_acl_id = aws_network_acl.open_nacl.id
  subnet_id      = aws_subnet.app_subnet_1a.id
}

resource "aws_network_acl_association" "subnet_2_association" {
  network_acl_id = aws_network_acl.open_nacl.id
  subnet_id      = aws_subnet.app_subnet_2a.id
}
