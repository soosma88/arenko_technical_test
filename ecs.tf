resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-cluster"
}

resource "aws_security_group" "ecs_sgrp" {
  name        = "sgrp-web-server"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}