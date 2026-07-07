output "vpc_id" {
  description = "ID of the Data Platform VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the Public Subnet (NAT Gateway)"
  value       = aws_subnet.public.id
}

output "private_subnet_1_id" {
  description = "ID of Private Subnet 1 — Databases (us-east-1a)"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "ID of Private Subnet 2 — Compute/Lambda (us-east-1b)"
  value       = aws_subnet.private_2.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway — destroy this after lab to stop billing"
  value       = aws_nat_gateway.main.id
}

output "elastic_ip" {
  description = "Elastic IP address allocated to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "public_route_table_id" {
  description = "ID of the Public Route Table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the Private Route Table"
  value       = aws_route_table.private.id
}

output "sg_public_nat_id" {
  description = "ID of sg-public-nat"
  value       = aws_security_group.public_nat.id
}

output "sg_private_compute_id" {
  description = "ID of sg-private-compute"
  value       = aws_security_group.private_compute.id
}

output "sg_private_db_id" {
  description = "ID of sg-private-db"
  value       = aws_security_group.private_db.id
}

output "vpc_endpoint_ids" {
  description = "IDs of all VPC endpoints"
  value = {
    s3               = aws_vpc_endpoint.s3.id
    dynamodb         = aws_vpc_endpoint.dynamodb.id
    secretsmanager   = aws_vpc_endpoint.secretsmanager.id
    cloudwatch_logs  = aws_vpc_endpoint.cloudwatch_logs.id
    sts              = aws_vpc_endpoint.sts.id
  }
}
