terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "cdem01-tfstate"
    key    = "lab-1.2-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = "DataPlatform"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = "1.2-VPC"
    Owner       = "CDEM01"
  }
}
