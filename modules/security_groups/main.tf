# Security group for virtual endpoints
resource "aws_security_group" "virtual_endpoints_sg" {
  name        = "virtual-endpoints-sg"
  description = "Security group for virtual endpoints with explicit ingress rules."
  vpc_id      = var.vpc_id

  tags = {
    Name = "VirtualEndpointsSG"
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs-task-sg"
  description = "Security group for ECS tasks, permitting traffic from the ALB and to virtual endpoints."
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "alb_security_group" {
  name        = "ouroboros-chat-alb-sg-prod"
  description = "Security group for the ouroboros-chat-tls-balancer"
  vpc_id      = var.vpc_id
}
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-security-group-prod"
  description = "Security group for the bastion"
  vpc_id = var.vpc_id
}

module "rule_implementations" {
  source = "./rules"
  virtual_endpoints_sg_id = aws_security_group.virtual_endpoints_sg.id
  ecs_task_sg_id = aws_security_group.ecs_task_sg.id
  alb_sg_id = aws_security_group.alb_security_group.id
  bastion_sg_id = aws_security_group.bastion_sg.id
}