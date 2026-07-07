variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "Region must be one of: us-east-1, us-west-2, eu-west-1."
  }
}

variable "environment" {
  description = "Deployment environment — controls resource tagging and naming"
  type        = string
  default     = "sandbox"

  validation {
    condition     = contains(["dev", "staging", "prod", "sandbox"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, sandbox."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block (e.g. 10.0.0.0/16)."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (NAT Gateway) in AZ 1"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "public_subnet_cidr must be a valid CIDR block."
  }
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1 (Databases) in AZ 1"
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_1_cidr, 0))
    error_message = "private_subnet_1_cidr must be a valid CIDR block."
  }
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2 (Compute/Lambda) in AZ 2"
  type        = string
  default     = "10.0.3.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_2_cidr, 0))
    error_message = "private_subnet_2_cidr must be a valid CIDR block."
  }
}

variable "availability_zones" {
  description = "List of exactly two availability zones — first for public + private-1, second for private-2"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones must be specified."
  }
}
