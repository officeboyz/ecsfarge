resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = {
    Name = "app-igw"
    environment = "sandbox"
  }
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.sandbox_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "app-route-table-sandbox"
    environment = "sandbox"
  }
}
resource "aws_route_table_association" "app_subnet_1_association" {
  subnet_id      = aws_subnet.app_subnet_1a.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table_association" "app_subnet_2_association" {
  subnet_id      = aws_subnet.app_subnet_2a.id
  route_table_id = aws_route_table.app_rt.id
}
