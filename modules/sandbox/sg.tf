resource "aws_security_group" "app_alb_sg" {
  name        = "sandbox-alb-sg"
  description = "Security group for the application load balancer"
  vpc_id      = aws_vpc.sandbox_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox alb sg"
    environment = "sandbox"
  }
}
resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg-2"
  description = "Security group for app allowing all traffic"
  vpc_id      = aws_vpc.sandbox_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}
