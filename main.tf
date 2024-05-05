provider "aws" {
  region  = "us-east-2"
  profile = "339713140717_AdministratorAccess"
}
variable "api_key" {
  description = "API key for accessing the service"
  type        = string
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "PublicSubnetIGW"
  }
}
module "security_group_config" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main_vpc.id
}

module "cidr" {
  source = "./modules/subnet/cidr"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  ipv4_cidr_block = aws_vpc.main_vpc.cidr_block
  ipv6_cidr_block = aws_vpc.main_vpc.ipv6_cidr_block
}
module "public_subnet" {
  source                = "./modules/subnet/public"
  vpc_id                = aws_vpc.main_vpc.id
  key_name              = "bastion_key_pair_2"
  ami_id                = "ami-080e449218d4434fa"
  instance_type         = "t2.micro"
  igw_id                = aws_internet_gateway.igw.id
  availability_cidr_map = module.cidr.cidr_map
  region                = "us-east-2"
  subnet_blocks         = module.cidr.subnet_blocks
  bastion_sg_id = module.security_group_config.bastion_sg_id
  alb_sg_id = module.security_group_config.alb_sg_id
}

module "private_subnet" {
  source                 = "./modules/subnet/private"
  vpc_id                 = aws_vpc.main_vpc.id
  ecs_task_sg_id = module.security_group_config.task_sg_id
  virtual_endpoint_sg_id = module.security_group_config.virtual_endpoint_sg_id
  availability_cidr_map = module.cidr.cidr_map
  load_balancer_arn = module.public_subnet.chat_tls_balancer_arn
  target_group_arn = module.public_subnet.target_group_arn
  subnet_blocks = module.cidr.subnet_blocks
  nat_gateway_ids = module.public_subnet.nat_gateway_ids
  api_key = var.api_key
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::ouroboros-cloudtrail-logs-prod",
        Principal = {
          Service = "cloudtrail.amazonaws.com",
        },
      },
      {
        Effect = "Allow",
        Action = "s3:PutObject",
        Resource = "arn:aws:s3:::ouroboros-cloudtrail-logs-prod/*",
        Principal = {
          Service = "cloudtrail.amazonaws.com",
        },
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          },
        },
      },
    ],
  })
}
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "ouroboros-cloudtrail-logs-prod"
}

resource "aws_cloudtrail" "main_cloudtrail" {
  name                          = "ouroboros-cloudtrail-refresh"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    data_resource {
      type = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}

module "sandbox" {
  source = "./modules/sandbox"
}

output "alb_endpoint" {
  value = module.public_subnet.balancer_endpoint
}

output "bastion_ips" {
  value = module.public_subnet.bastion_ip
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "bastion_sg_id" {
  value = module.security_group_config.bastion_sg_id
}
output "sandbox_ec2_test_public_ip" {
  value = module.sandbox.ec2_test_public_ip
}
output "sandbox_ecr_url" {
  value = module.sandbox.ecr_url
}
output "sandbox_instance_id" {
  value = module.sandbox.instance_id
}

