# -----------------------------------------------------------------------------
# Networking Outputs
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the lab VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block assigned to the lab VPC."
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the lab VPC."
  value       = aws_internet_gateway.main.id
}

output "public_subnet_id" {
  description = "ID of the public egress subnet."
  value       = aws_subnet.public.id
}

output "public_subnet_cidr" {
  description = "CIDR block assigned to the public egress subnet."
  value       = aws_subnet.public.cidr_block
}

output "private_subnet_id" {
  description = "ID of the private workload subnet."
  value       = aws_subnet.private.id
}

output "private_subnet_cidr" {
  description = "CIDR block assigned to the private workload subnet."
  value       = aws_subnet.private.cidr_block
}

output "public_route_table_id" {
  description = "ID of the public subnet route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private workload subnet route table."
  value       = aws_route_table.private.id
}

# -----------------------------------------------------------------------------
# NAT / Egress Outputs
# -----------------------------------------------------------------------------

output "nat_instance_id" {
  description = "EC2 instance ID of the NAT/egress host."
  value       = aws_instance.nat.id
}

output "nat_private_ip" {
  description = "Private IPv4 address of the NAT/egress host."
  value       = aws_instance.nat.private_ip
}

output "nat_public_ip" {
  description = "Elastic public IPv4 address assigned to the NAT/egress host."
  value       = aws_eip.nat.public_ip
}

output "nat_security_group_id" {
  description = "Security group assigned to the NAT/egress host."
  value       = aws_security_group.nat.id
}

output "ec2_ssm_instance_profile" {
  description = "Reusable EC2 instance profile providing Systems Manager access."
  value       = aws_iam_instance_profile.ec2_ssm.name
}