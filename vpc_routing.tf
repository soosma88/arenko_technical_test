### Public Subnet Routing ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

### Private Subnet Routing ###
resource "aws_route_table" "rt_aza" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-a.id
  }
}