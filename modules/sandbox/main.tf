module "ecs_execution_role" {
  source = "./execution-role-2"
}

resource "aws_ecr_repository" "sandbox_repository" {
  name                 = "app-repository-sandbox-3"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {environment = "sandbox"}
}

resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.sandbox_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sandbox_tg.arn
  }
}

output "ec2_test_public_ip" {
  value = aws_instance.ec2_test.public_ip
}
output "ecr_url" {
  value = aws_ecr_repository.sandbox_repository.repository_url
}
output "instance_id" {
  value = aws_instance.ec2_test.id
}

output "sg_id" {
  value = aws_security_group.sandbox_sg.id
}
output "subnet_ids" {
  value = tolist([aws_subnet.app_subnet_1a.id, aws_subnet.app_subnet_2a.id])
}
