resource "aws_security_group" "public_nat" {
  name        = "public-nat"
  description = "Security group for public NAT - allows HTTPS outbound from private resources"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "sg-public-nat"
  })
}

resource "aws_security_group" "private_compute" {
  name        = "private-compute"
  description = "Security group for private compute resources (EC2, Lambda, Glue)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow all traffic from public NAT SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_nat.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "sg-private-compute"
  })
}

# Self-referencing rule added separately to avoid circular dependency
resource "aws_security_group_rule" "private_compute_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.private_compute.id
  security_group_id        = aws_security_group.private_compute.id
  description              = "Allow all traffic from itself"
}

resource "aws_security_group" "private_db" {
  name        = "private-db"
  description = "Security group for private databases - accepts traffic from compute layer only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from compute layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_compute.id]
  }

  ingress {
    description     = "PostgreSQL from compute layer"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_compute.id]
  }

  egress {
    description = "Allow responses within VPC only - databases must not initiate outbound internet connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(local.common_tags, {
    Name = "sg-private-db"
  })
}
