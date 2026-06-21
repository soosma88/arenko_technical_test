resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.postgres_rds.id
  engine                 = "postgres"
  engine_version         = "postgres17"   # Set to latest version
  instance_class         = "db.t4g.micro" # Set to latest db instance class
  multi_az               = true
  db_name                = "${var.environment}-mydb"
  username               = "db_admin"
  password               = random_password.prod_postgresql_db_password.result # Use Generated Password for master password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sgrp.id]
}

resource "aws_db_subnet_group" "postgres_rds" {
  name       = "${var.environment}_postgres_rds"
  subnet_ids = [aws_subnet.database-1.id, aws_subnet.database-2.id]
  tags       = { Name = "Postgres RDS Private Subnet Group" }
}

resource "aws_security_group" "database-sgrp" {
  name        = "sgrp-${var.environment}-database"
  description = "Allow inbound traffic from application security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from ecs application layer"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sgrp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}