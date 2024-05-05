resource "aws_lb_target_group" "sandbox_tg" {
  name     = "sandbox-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sandbox_vpc.id
  target_type = "ip" # This must be set to 'ip' for compatibility with 'awsvpc' network mode

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = {
    Name = "sandbox-target-group"
  }
}

resource "aws_lb" "sandbox_alb" {
  name               = "sandbox-alb-2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = [aws_subnet.app_subnet_1a.id, aws_subnet.app_subnet_2a.id]

  enable_deletion_protection = false

  tags = {
    Name = "sandbox-alb"
    environment = "sandbox"
  }
}
