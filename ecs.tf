resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-nginx-cluster"
}

resource "aws_security_group" "ecs_sgrp" {
  name        = "sgrp-${var.environment}-ecs"
  description = "Allowed to ECS Cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "ALB traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_alb_sgrp.id]
  }

  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}