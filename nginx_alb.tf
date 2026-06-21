resource "aws_lb" "nginx_alb" {
  name               = "${var.environment}-nginx-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  security_groups    = [aws_security_group.nginx_alb_sgrp.id]

  enable_deletion_protection = false

  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.environment}-nginx-alb"
  }
}

### Default Listener rule ###
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  name        = "${var.environment}-nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path = "/"
  }

}

resource "aws_security_group" "nginx_alb_sgrp" {
  name        = "sgrp-${var.environment}-nginx-alb"
  description = "${upper(var.environment)} NGINX ALB security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
