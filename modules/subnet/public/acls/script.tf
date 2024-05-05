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



variable "vpc_id" {
  type = string
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
    { # ssh
      protocol    = "tcp"
      port_number = 22
    },
    { # dns
      protocol    = "udp"
      port_number = 53
    }  
    
    ]  
}
resource "aws_network_acl" "public_subnet_acl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public-subnet-nacl"
  }
}


module "bastion_ssh_exception" {
  source = "../../rules/cartesian_rule_builder"
  cidrs  = [{ 
    ipv4_cidr = "0.0.0.0/0"
    ipv6_cidr = "::/0"
  }]
  nacl_id = aws_network_acl.public_subnet_acl.id
  protocol_port_pairs = [{
    protocol = "tcp"
    port_number = 22
  }]
  ipv4 = true
  ipv6 = true
  initial_offset = pow(2,8)
}


module "load_balancer_exception" {
  source = "../../rules/cartesian_rule_builder"
  cidrs  = [{
    ipv4_cidr = "0.0.0.0/0"
    ipv6_cidr = "::/0"
  }]
  nacl_id = aws_network_acl.public_subnet_acl.id
  protocol_port_pairs = [{
    protocol   = "tcp"
    port_number = 443
  }]
  ipv4 = true
  ipv6 = true
  initial_offset = pow(2,6)
}

module "inter-subnet-comms" {
  source = "../../rules/cartesian_rule_builder"
  cidrs  = [{
    ipv4_cidr = var.subnet_blocks.public.ipv4
    ipv6_cidr = var.subnet_blocks.public.ipv6
  }, {
    ipv4_cidr = var.subnet_blocks.private.ipv4
    ipv6_cidr = var.subnet_blocks.private.ipv6
  }]

  nacl_id = aws_network_acl.public_subnet_acl.id
  protocol_port_pairs = local.permitted_protocols
  ipv4 = false
  ipv6 = true
}

output "nacl_id" {
  value = aws_network_acl.public_subnet_acl.id
}