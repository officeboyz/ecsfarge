resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = var.db_subnet_group_ids

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = var.db_allocated_storage
  storage_type         = var.db_storage_type
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  identifier = "my-rds-instance"
  db_name                 = "mydb"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot   = true

  tags = {
    Name = "MyDatabaseInstance"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "db-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "PostgreSQL from bastion"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}