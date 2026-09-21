resource "aws_security_group" "rds_postgres" {
  name        = "${var.environment}-rds-postgres-sg"
  description = "Strict inbound controls for Enterprise Aurora PostgreSQL"
  vpc_id      = aws_vpc.enterprise.id

  ingress {
    description     = "PostgreSQL access from internal application security groups"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_tier.id] 
  }

  egress {
    description = "Allow all outbound traffic for patching/telemetry"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.environment}-rds-postgres-sg" }
}

resource "aws_security_group" "app_tier" {
  name        = "${var.environment}-app-tier-sg"
  description = "App tier placeholder"
  vpc_id      = aws_vpc.enterprise.id
}
