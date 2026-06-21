### Public Subnet Routing ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public subnet route table"
  }

  route {
    cidr_block = "0.0.0.0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

### Private Subnet Routing ###
# AZ-A Route Table #
resource "aws_route_table" "private_rt_aza" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private subnet AZ-A route table"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-a.id
  }
}


# # AZ-B Route Table #
# resource "aws_route_table" "private_rt_azb" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name = "private subnet AZ-B route table"
#   }
#
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat-az-b.id
#   }
# }