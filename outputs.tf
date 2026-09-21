output "cluster_writer_endpoint" {
  value       = aws_rds_cluster.aurora_postgres.endpoint
  description = "Cluster Writer Endpoint for application database writes"
}

output "cluster_reader_endpoint" {
  value       = aws_rds_cluster.aurora_postgres.reader_endpoint
  description = "Load-balanced Read-Only Endpoint for analytical queries and scaling reads"
}

output "secrets_manager_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "ARN of the AWS Secrets Manager secret containing database master credentials"
}
