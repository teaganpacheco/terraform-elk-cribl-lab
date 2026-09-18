# -----------------------------------------------------------------------------
# NAT / Egress Instance Security Group
#
# Private workloads may use the NAT instance for HTTP and HTTPS only.
# No inbound Internet access is permitted.
# -----------------------------------------------------------------------------

resource "aws_security_group" "nat" {
  name        = "${local.name_prefix}-nat-sg"
  description = "Controls traffic through the NAT/egress instance"
  vpc_id      = aws_vpc.main.id

  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-nat-sg"
  }
}


# -----------------------------------------------------------------------------
# Inbound forwarding traffic from private workloads
# -----------------------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "nat_http_from_private" {
  security_group_id = aws_security_group.nat.id

  description = "Allow HTTP traffic from the private workload subnet"
  cidr_ipv4   = var.private_subnet_cidr
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "nat_https_from_private" {
  security_group_id = aws_security_group.nat.id

  description = "Allow HTTPS traffic from the private workload subnet"
  cidr_ipv4   = var.private_subnet_cidr
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}


# -----------------------------------------------------------------------------
# Internet-bound traffic
# -----------------------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "nat_http_to_internet" {
  security_group_id = aws_security_group.nat.id

  description = "Allow outbound HTTP traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "nat_https_to_internet" {
  security_group_id = aws_security_group.nat.id

  description = "Allow outbound HTTPS traffic"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}