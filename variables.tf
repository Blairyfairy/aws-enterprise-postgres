variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Target AWS Region"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Deployment environment tag"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.100.0.0/16"
  description = "CIDR block for the enterprise VPC"
}

variable "db_master_username" {
  type        = string
  default     = "dbadmin"
  description = "Master username for PostgreSQL"
}

variable "aurora_instance_class" {
  type        = string
  default     = "db.r6g.2xlarge"
  description = "Memory-optimized instance class for enterprise workload performance"
}
