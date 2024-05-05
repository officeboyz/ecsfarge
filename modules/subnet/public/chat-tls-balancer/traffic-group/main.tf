resource "aws_lb_target_group" "ouroboros_chat_traffic_group" {
  name     = "ouroboros-chat-traffic-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/checks/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
  }

}
