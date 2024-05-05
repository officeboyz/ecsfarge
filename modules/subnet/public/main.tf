resource "aws_subnet" "public_subnet" {
  for_each = var.availability_cidr_map
  vpc_id            = var.vpc_id
  cidr_block        = each.value.public.ipv4_cidr
  ipv6_cidr_block   = each.value.public.ipv6_cidr
  availability_zone = each.key
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${each.key}"  # Ensure unique names using the availability zone
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = var.igw_id
  }

  tags = {
    Name = "PublicSubnetRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}



module "bastion" {
  source            = "./bastion"
  vpc_id            = var.vpc_id
  public_subnet_ids = values(aws_subnet.public_subnet).*.id
  key_name          = var.key_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  bastion_sg_id = var.bastion_sg_id
}

module "chat_tls_balancer" {
  source = "./chat-tls-balancer"
  subnet_ids = values(aws_subnet.public_subnet).*.id
  alb_sg_id = var.alb_sg_id
  vpc_id = var.vpc_id
}

module "public_acl" {
  source = "./acls"
  subnet_blocks = var.subnet_blocks
  vpc_id                = var.vpc_id
}

resource "aws_network_acl_association" "public_subnet_nacl_association" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  network_acl_id = module.public_acl.nacl_id
}

module "nat" {
  for_each = aws_subnet.public_subnet
  source = "./nat-gateway"
  public_subnet_id = each.value.id
  vpc_id = var.vpc_id
}