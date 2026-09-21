resource "random_password" "master_password" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name_prefix = "${var.environment}-aurora-postgres-creds-"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_rds_cluster.aurora_postgres.endpoint
    port     = 5432
    username = var.db_master_username
    password = random_password.master_password.result
    database = "enterprise_production"
  })
}

resource "aws_rds_cluster_parameter_group" "enterprise" {
  name        = "${var.environment}-aurora-pg15-parameter-group"
  family      = "aurora-postgresql15"
  description = "Enterprise high-performance parameter tuning"

  parameter {
    name  = "shared_buffers"
    value = "{DBInstanceClassMemory/4}"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "max_connections"
    value = "1000"
    apply_method = "immediate"
  }

  parameter {
    name  = "log_statement"
    value = "mod"
    apply_method = "immediate"
  }
}

resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier     = "${var.environment}-enterprise-postgres-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = "15.4"
  database_name          = "enterprise_production"
  master_username        = var.db_master_username
  master_password        = random_password.master_password.result
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.rds_postgres.id]

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.enterprise.name

  storage_encrypted   = true
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.environment}-enterprise-postgres-final-snapshot"

  backup_retention_period   = 35
  preferred_backup_window   = "03:00-04:00"
  preferred_maintenance_window = "sun:04:30-sun:05:30"

  copy_tags_to_snapshot   = true
  enable_http_endpoint    = false

  tags = { Name = "${var.environment}-aurora-postgres-cluster" }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 3
  identifier         = "${var.environment}-enterprise-postgres-node-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_postgres.id
  instance_class     = var.aurora_instance_class
  engine             = aws_rds_cluster.aurora_postgres.engine
  engine_version     = aws_rds_cluster.aurora_postgres.engine_version

  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  publicly_accessible     = false
  auto_minor_version_upgrade = true
  performance_insights_enabled = true
  performance_insights_retention_period = 7

  tags = { Name = "${var.environment}-aurora-postgres-instance-${count.index + 1}" }
}
