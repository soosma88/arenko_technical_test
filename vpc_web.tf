### Web Subnets ###
resource "aws_subnet" "web-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

  tags = { Name = "web-1-private" }
}

resource "aws_route_table_association" "web_1" {
  subnet_id      = aws_subnet.web-1.id
  route_table_id = aws_route_table.private_rt_aza.id
}

resource "aws_subnet" "web-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false

  tags = { Name = "web-2-private" }
}

resource "aws_route_table_association" "web_2" {
  subnet_id      = aws_subnet.web-2.id
  route_table_id = aws_route_table.private_rt_aza.id
  # route_table_id = aws_route_table.private_rt_azb.id
}