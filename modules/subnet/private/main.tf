resource "aws_subnet" "private_subnet" {
  for_each = { for az, cidrs in var.availability_cidr_map : az => cidrs.private }

  vpc_id            = var.vpc_id
  availability_zone = each.key
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block   = each.value.ipv6_cidr
  cidr_block = each.value.ipv4_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "PrivateSubnet-${each.key}"
  }
}


resource "aws_network_acl" "private_subnet_acl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private-subnet-nacl"
  }
}

module "acls" {
  source = "./acls"
  subnet_blocks = var.subnet_blocks
  nacl_id = aws_network_acl.private_subnet_acl.id
}
resource "aws_network_acl_association" "private_subnet_nacl_association" {
  for_each = aws_subnet.private_subnet

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private_subnet_acl.id
}

resource "aws_egress_only_internet_gateway" "ipv6_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private-egress-igw"
  }
}

resource "aws_route_table" "private_route_table" {
  count = length(var.nat_gateway_ids)
  vpc_id = var.vpc_id

  route { # All traffic not covered with a more specific rule goes to the NAT
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_ids[count.index]
  }

  # Additional route for IPv6 traffic using an Egress-Only Internet Gateway
  route {
    ipv6_cidr_block     = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.ipv6_igw.id
  }

  tags = {
    Name = "PrivateSubnetRouteTable"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count =  length(aws_subnet.private_subnet)

  subnet_id      = values(aws_subnet.private_subnet)[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}


module "execution-role" {
  source = "./ecs/execution-role"
}
module "task" {
  source = "./ecs/task"
  image_tag = "15"
  execution_role_arn = module.execution-role.ecs_execution_role_arn
  ecs_task_sg_id = var.ecs_task_sg_id
  subnet_ids = values(aws_subnet.private_subnet).*.id
  api_key = var.api_key
}

resource "aws_ecs_cluster" "ouroboros-app-cluster" {
  name = "ouroboros-app-ecs"
  tags = {
    Name = "Ouroboros_Cluster"
  }
}

module "service" {
  source = "./ecs/service"
  cluster_arn = aws_ecs_cluster.ouroboros-app-cluster.arn
  load_balancer_arn = var.load_balancer_arn
  security_group_id = var.ecs_task_sg_id
  subnet_ids = values(aws_subnet.private_subnet).*.id
  target_group_arn = var.target_group_arn
  task_definition_arn = module.task.task_definition_arn
}

#
# module "virtual_endpoints" {
#   source             = "./virtual_endpoints"
#   vpc_id             = var.vpc_id
#   subnet_ids         = [for az, s in aws_subnet.private_subnet : s.id]
#   security_group_for_endpoint_policies = var.virtual_endpoint_sg_id
#   aws_region         = "us-east-2"
# }