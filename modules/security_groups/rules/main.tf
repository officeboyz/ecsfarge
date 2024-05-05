# Virtual endpoint rules
resource "aws_security_group_rule" "virtual_endpoints_ingress" {
  description = "Task traffic can enter virtual endpoints via https"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.virtual_endpoints_sg_id
  source_security_group_id = var.ecs_task_sg_id
}
resource "aws_security_group_rule" "ecs_task_egress" {
  description = "Allow ECS task traffic to head towards virtual endpoints on HTTPS"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.ecs_task_sg_id
  ipv6_cidr_blocks = ["::/0"]
#   source_security_group_id = var.virtual_endpoints_sg_id
}
resource "aws_security_group_rule" "ecs_task_egress_hack" {
  description = "Allow ECS task traffic to head towards anything because aws is behind the curve on ipv6 s3 gateways HTTPS"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.ecs_task_sg_id
  cidr_blocks = ["0.0.0.0/0"]
}
# Bastion rules
resource "aws_security_group_rule" "bastion_ingress" {
  description = "SSH from anywhere"
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = var.bastion_sg_id
}

resource "aws_security_group_rule" "bastion_ingress_ipv6" {
  description = "SSH from anywhere"
  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = var.bastion_sg_id
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "bastion_ingress_icmp" {
  description = "Allow icmp from anywhere"
  type = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = var.bastion_sg_id
}

resource "aws_security_group_rule" "bastion_ingress_ipv6_icmp" {
  description = "SSH from anywhere"
  type = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  security_group_id = var.bastion_sg_id
  ipv6_cidr_blocks = ["::/0"]
}
resource "aws_security_group_rule" "bastion_ipv4_egress" {
  description = "Allow all outbound ipv4 traffic"
  type = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = var.bastion_sg_id
 }
resource "aws_security_group_rule" "bastion_ipv6_egress" {
  description = "Allow all outbound ipv6 traffic"
  type = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  security_group_id = var.bastion_sg_id
  ipv6_cidr_blocks = ["::/0"]
}

# alb rules
resource "aws_security_group_rule" "alb_sg_egress" {
  description = "Allow application traffic from ALB to ECS task"
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = var.ecs_task_sg_id
  security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "task_ingress_from_alb" {
  description = "Allow ecs task to receive alb traffic"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = var.alb_sg_id
  security_group_id = var.ecs_task_sg_id
}

resource "aws_security_group_rule" "alb_sg_ingress_https_ipv4" {
  description = "Allows all inbound ipv4 https traffic to alb"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = var.alb_sg_id
}
resource "aws_security_group_rule" "alb_sg_ingress_https_ipv6" {
  description = "Allows all inbound ipv6 https traffic to alb"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "alb_sg_ingress_https_bastion" {
  description = "Explicitly allows bastion regardless of other rules"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.alb_sg_id
  source_security_group_id   = var.bastion_sg_id
}