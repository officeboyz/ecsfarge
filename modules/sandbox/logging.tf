resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.sandbox_vpc.id
}

resource "aws_iam_role" "flow_log_role" {
  name = "flow_log_role_sandbox"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
      },
    ],
  })
}
resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "vpc-flow-logs-group-sandbox"
}
