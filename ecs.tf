resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-cluster"
}