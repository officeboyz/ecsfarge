resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs"

  retention_in_days = 14 // Set retention as appropriate
}


resource "aws_ecs_task_definition" "webserver" {
  family                   = "Ouroboros-webserver"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn = var.execution_role_arn
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["FARGATE"]

  container_definitions    = jsonencode([
    {
      name        = "webserver"
      image       = "339713140717.dkr.ecr.us-east-2.amazonaws.com/ouroboros-ai-webserver:${var.image_tag}"
      cpu         = 0
      essential   = true
      environment = [
        {
          name  = "API_KEY"
          value = var.api_key
        }
      ],
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name,
          "awslogs-region"        = "us-east-2",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])


}


