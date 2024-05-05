resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  #public_key = file("C:/DevWithoutSpace/aws/bastion_key.pub")
   public_key = file("bastion_key.pub")
}

resource "aws_launch_template" "bastion_lt" {
  name                   = "bastion-launch-template-prod-2"
  image_id               =  var.ami_id
  instance_type          =  var.instance_type
  #key_name               = aws_key_pair.bastion_key.key_name
  key_name  = "test" 

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.bastion_sg_id]
  }
  tags = {name = "bastion"}
}




resource "aws_autoscaling_group" "bastion" {
  max_size = 1
  min_size = 1
  vpc_zone_identifier = var.public_subnet_ids
  launch_template {
    id = aws_launch_template.bastion_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Bastion Host"
    propagate_at_launch = true
  }
}
# First, create a data source to fetch the details of the Auto Scaling Group
data "aws_autoscaling_group" "bastion_asg" {
  name = aws_autoscaling_group.bastion.name
}

# Then, create a data source to fetch instances based on the Auto Scaling Group
data "aws_instances" "bastion_host" {
  instance_tags = {
    "aws:autoscaling:groupName" = data.aws_autoscaling_group.bastion_asg.name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}
resource "aws_cloudwatch_log_group" "bastion_log_group" {
  name = "cloudwatch-logs"

  retention_in_days = 14 // Set retention as appropriate
}



resource "aws_iam_role" "flow_log_role" {
  name = "flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name = "flow-log-policy"
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
      }
    ]
  })
}

resource "aws_flow_log" "bastion_flow_log" {
  log_destination      = aws_cloudwatch_log_group.bastion_log_group.arn
  iam_role_arn = aws_iam_role.flow_log_role.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  log_destination_type = "cloud-watch-logs"
  log_format           = "$${start} $${interface-id} $${srcaddr} $${dstaddr} $${dstport} $${protocol} $${action} $${log-status}"

  tags = {
    Name = "BastionFlowLog"
  }
}
