resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.postgres_rds.id
  engine                 = "postgres"
  engine_version         = "postgres17"
  instance_class         = "db.t4g.micro"
  multi_az               = true
  db_name                = "mydb"
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sgrp.id]
}

resource "aws_db_subnet_group" "postgres_rds" {
  name       = "postgres_rds"
  subnet_ids = [aws_subnet.database-1.id, aws_subnet.database-2.id]
}

resource "aws_security_group" "database-sgrp" {
  name        = "sgrp-database"
  description = "Allow inbound traffic from application security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow traffic from ecs application layer"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sgrp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}