resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key_sandbox"
  #public_key = file("C:/DevWithoutSpace/aws/bastion_key.pub")
  public_key = file("bastion_key.pub")
}


resource "aws_instance" "ec2_test" {
  ami           = "ami-080e449218d4434fa" # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro" # Free tier eligible instance
  associate_public_ip_address = true
  subnet_id              = aws_subnet.app_subnet_1a.id # Same as ECS task routing.tf
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id] # Same as ECS task security group
  iam_instance_profile   = aws_iam_instance_profile.ecs_execution_profile.name
  #key_name = aws_key_pair.bastion_key.key_name # Replace with your EC2 key pair name
  key_name = "test"
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-2.amazonaws.com/app-repository-sandbox-3
              docker pull $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-2.amazonaws.com/app-repository-sandbox-3:latest
              EOF
  tags = {
    Name = "ECR-Connectivity-Test"
    environment = "sandbox"
  }
}

resource "aws_launch_template" "bastion_lt" {
  name_prefix   = "sandbox-bastion-lt-"
  image_id      = "ami-080e449218d4434fa"  # Amazon Linux 2 AMI (HVM)
  instance_type = "t2.micro"

  key_name = aws_key_pair.bastion_key.key_name

  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_execution_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.sandbox_sg.id]
    associate_public_ip_address = true
    delete_on_termination = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-2.amazonaws.com/app-repository-sandbox-3
              docker pull $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-2.amazonaws.com/app-repository-sandbox-3:latest
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "sandbox-bastion-autoscaling-instance"
      environment = "sandbox"
    }
  }
}
# resource "aws_autoscaling_group" "bastion_asg" {
#   launch_template {
#     id      = aws_launch_template.bastion_lt.id
#     version = "$Latest"
#   }
#
#   min_size         = 1
#   max_size         = 1
#   desired_capacity = 1
#
#   vpc_zone_identifier = [aws_subnet.app_subnet_1a.id, aws_subnet.app_subnet_2a.id]  # Using variable for subnets across different AZs
#
#   tag {
#     key                 = "Name"
#     value               = "sandbox-bastion-autoscale"
#     propagate_at_launch = true
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
# }


