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

# -----------------------------------------------------------------------------
# Linux Endpoint Security Group
#
# This endpoint is administered through AWS Systems Manager.
#
# No inbound rules are required.
#
# Outbound Internet connectivity is restricted to HTTP/HTTPS and traverses
# the NAT/egress instance.
# -----------------------------------------------------------------------------

resource "aws_security_group" "linux_endpoint" {
  name        = "${local.name_prefix}-linux-endpoint-sg"
  description = "Security group for the private Linux endpoint"
  vpc_id      = aws_vpc.main.id

  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-linux-endpoint-sg"
  }
}


# -----------------------------------------------------------------------------
# Outbound HTTP
#
# Used for operating-system repositories and package retrieval.
# -----------------------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "linux_endpoint_http" {
  security_group_id = aws_security_group.linux_endpoint.id

  description = "Allow outbound HTTP through the NAT instance"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}


# -----------------------------------------------------------------------------
# Outbound HTTPS
#
# Used for AWS Systems Manager, HTTPS repositories, Cribl downloads, GitHub,
# and other TLS-protected services.
# -----------------------------------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "linux_endpoint_https" {
  security_group_id = aws_security_group.linux_endpoint.id

  description = "Allow outbound HTTPS through the NAT instance"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# -----------------------------------------------------------------------------
# Windows Endpoint Security Group
# -----------------------------------------------------------------------------

resource "aws_security_group" "windows_endpoint" {
  name        = "${local.name_prefix}-windows-endpoint-sg"
  description = "Security group for the private Windows endpoint"
  vpc_id      = aws_vpc.main.id

  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-windows-endpoint-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "windows_endpoint_http" {
  security_group_id = aws_security_group.windows_endpoint.id

  description = "Allow outbound HTTP through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "windows_endpoint_https" {
  security_group_id = aws_security_group.windows_endpoint.id

  description = "Allow outbound HTTPS through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# -----------------------------------------------------------------------------
# Cribl Stream Security Group
#
# Application ingress will be added during Phase 3.
# -----------------------------------------------------------------------------

resource "aws_security_group" "cribl_stream" {
  name        = "${local.name_prefix}-cribl-stream-sg"
  description = "Security group for the private Cribl Stream server"
  vpc_id      = aws_vpc.main.id

  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-cribl-stream-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "cribl_stream_http" {
  security_group_id = aws_security_group.cribl_stream.id

  description = "Allow outbound HTTP through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "cribl_stream_https" {
  security_group_id = aws_security_group.cribl_stream.id

  description = "Allow outbound HTTPS through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# -----------------------------------------------------------------------------
# Elastic / Kibana Security Group
#
# Elasticsearch and Kibana ingress will be added during Phase 4.
# -----------------------------------------------------------------------------

resource "aws_security_group" "elastic" {
  name        = "${local.name_prefix}-elastic-sg"
  description = "Security group for the private Elastic/Kibana server"
  vpc_id      = aws_vpc.main.id

  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-elastic-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "elastic_http" {
  security_group_id = aws_security_group.elastic.id

  description = "Allow outbound HTTP through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "elastic_https" {
  security_group_id = aws_security_group.elastic.id

  description = "Allow outbound HTTPS through NAT"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}