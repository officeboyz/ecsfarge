resource "aws_vpc" "sandbox_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "sandbox-vpc"
    environment = "sandbox"
  }
}

resource "aws_subnet" "app_subnet_1a" {
  vpc_id     = aws_vpc.sandbox_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-2a"

  tags = {
    Name = "app-subnet-1"
  }
}

resource "aws_subnet" "app_subnet_2a" {
  vpc_id     = aws_vpc.sandbox_vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-2b"

  tags = {
    Name = "app-subnet-2"
  }
}
