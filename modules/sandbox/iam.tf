resource "aws_iam_instance_profile" "ecs_execution_profile" {
  name = "sandbox_ecs_execution_profile"
  role = module.ecs_execution_role.ecs_execution_role_name
}
resource "aws_iam_role_policy" "flow_log_policy" {
  name = "sandbox_flow_log_policy"
  role = aws_iam_role.flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
        ],
        Effect = "Allow",
        Resource = "*",
      },
    ],
  })
}

