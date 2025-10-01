terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "lncr-prd-terraform-state"
    key            = "database/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lncr-prd-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "postgresql"
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "database"
    }
  }
}
