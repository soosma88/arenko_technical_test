resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat-az-a" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.nat_a.id

  depends_on = [
    aws_subnet.public-1
  ]
}

resource "aws_eip" "nat_a" {
  domain = "vpc"
}