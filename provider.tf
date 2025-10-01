terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #Backend local temporário até que o bucket S3 seja criado
  #Para usar o backend S3, descomente as linhas abaixo após criar o bucket
  backend "s3" {
    bucket         = "lncr-prd-terraform-state"
    key            = "database/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lncr-prd-terraform-locks"
    encrypt        = true
  }
}

