resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach IAM Policy for ECR/Docker Image access to ECS execution role
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Policy for SSM Parameter Store access for RDS credential
resource "aws_iam_policy" "ecs_ssm_policy" {
  name        = "ecs-ssm-read-policy"
  description = "Allows ECS to read database secret from SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameters"]
        Resource = [aws_ssm_parameter.prod_postgresql_db_pass.arn]
      }
    ]
  })
}

# Attach IAM Policy for SSM Parameter Store access to ECS execution role - ### Uncomment if ECS nginx_task requires access to RDS ###
# resource "aws_iam_role_policy_attachment" "ecs_execution_ssm" {
#   role       = aws_iam_role.ecs_execution_role.name
#   policy_arn = aws_iam_policy.ecs_ssm_policy.arn
# }