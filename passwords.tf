# Generate Random Master Password for postgresql RDS
resource "random_password" "prod_postgresql_db_password" {
  length  = 16
  special = false # Avoid special chars that might break connection strings
}

# Store Generated Password in Parameter Store for credential referencing.
resource "aws_ssm_parameter" "prod_postgresql_db_pass" {
  name        = "/prod/database/postgresql/password"
  description = "${upper(var.environment)} PostgreSQL RDS Master Password"
  type        = "SecureString"
  value       = random_password.prod_postgresql_db_password.result
}
