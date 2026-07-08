terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Using local state — DCE environment does not permit S3 bucket creation
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
