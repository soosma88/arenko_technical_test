resource "aws_lb_target_group_attachment" "nginx_target_group_attachment" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = aws_ecs_service.nginx_service.name
}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.environment}-${var.service}"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.web-1.id, aws_subnet.web-2.id]
    security_groups  = [aws_security_group.ecs_sgrp.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.nginx_listener]
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name      = "nginx-container"
    image     = "nginx:latest"
    essential = true
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }]
    # environment = [   ### Uncomment if nginx_task requires access to RDS ###
    #   { name = "DB_HOST", value = aws_db_instance.rds.address },
    #   { name = "DB_PORT", value = "5432" },
    #   { name = "DB_NAME", value = aws_db_instance.rds.db_name },
    #   { name = "DB_USER", value = aws_db_instance.rds.username }
    # ]
    # secrets = [
    #   {
    #     name      = "DB_PASSWORD"
    #     valueFrom = aws_ssm_parameter.prod_postgresql_db_pass.arn
    #   }
    # ]
  }])
}

