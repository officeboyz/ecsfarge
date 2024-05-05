resource "aws_ecs_service" "ouroboros_chat_service" {
  name            = "ouroboros-chat-service"
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "webserver"
    container_port   = 8080
  }

  network_configuration {
    subnets = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }
}