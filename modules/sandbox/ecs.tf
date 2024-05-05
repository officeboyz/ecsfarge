#
#
# resource "aws_ecs_cluster" "app_cluster" {
#   name = "sandbox_cluster"
#   tags = {environment = "sandbox"}
# }
#
# resource "aws_ecs_task_definition" "app" {
#   family                = "ouroboros_sandbox"
#   cpu                   = "256"
#   memory                = "512"
#   network_mode          = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn    = module.ecs_execution_role.ecs_execution_role_arn
#   task_role_arn         = module.ecs_execution_role.ecs_task_role_arn
#
#   container_definitions = jsonencode([
#     {
#       name  = "sandbox-container"
#       image = "${aws_ecr_repository.sandbox_repository.repository_url}:latest"
#       portMappings = [{
#         containerPort = 80
#         hostPort      = 80
#       }]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = "/sandbox/ecs/"
#           awslogs-region        = "us-east-2"
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
#   tags = {environment = "sandbox"}
# }
#
# resource "aws_ecs_service" "sandbox_service_2" {
#   name            = "sandbox-service_2"
#   cluster         = aws_ecs_cluster.app_cluster.id
#   task_definition = aws_ecs_task_definition.app.arn
#   launch_type     = "FARGATE"
#
#   desired_count   = 1
#
#   network_configuration {
#     subnets = [aws_subnet.app_subnet_1a.id, aws_subnet.app_subnet_2a.id]
#     security_groups = [aws_security_group.sandbox_sg.id]
#     assign_public_ip = true
#   }
#   load_balancer {
#     target_group_arn = aws_lb_target_group.sandbox_tg.arn
#     container_name   = "sandbox-container"
#     container_port   = 80
#   }
#
# }
