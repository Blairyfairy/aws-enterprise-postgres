terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    bucket         = "your-enterprise-tf-state-bucket"
    key            = "infrastructure/prod/aurora-postgres/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "your-enterprise-tf-lock-table"
  }
}
