resource "aws_lb" "ouroboros_chat_tls_balancer" {
  name               = "ouroboros-chat-tls-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false // Set to true for production

  ip_address_type    = "dualstack"

  tags = {
    Name = "Ouroboros-Chat-ALB"
  }
}

module "traffic-group" {
  source = "./traffic-group"
  vpc_id = var.vpc_id
}
module "listener" {
  source = "./listener"
  alb_arn = aws_lb.ouroboros_chat_tls_balancer.arn
  certificate_arn = "arn:aws:acm:us-east-2:339713140717:certificate/ece54212-154a-4f29-9783-adf80d69c8a8"
  target_group_arn = module.traffic-group.target_group_arn
}