# -----------------------------------------------------------------------------
# Virtual Private Cloud
# -----------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}


# -----------------------------------------------------------------------------
# Internet Gateway
# -----------------------------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}


# -----------------------------------------------------------------------------
# Public Egress Subnet
#
# This subnet will eventually contain the NAT/egress EC2 instance.
# Automatic public IPv4 assignment remains disabled. The NAT instance will
# receive an Elastic IP explicitly.
# -----------------------------------------------------------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-public-${local.availability_zone}"
    Tier = "public"
  }
}


# -----------------------------------------------------------------------------
# Private Workload Subnet
#
# Windows, Linux, Cribl Stream, and Elastic workloads will eventually reside
# here and will not receive public IPv4 addresses.
# -----------------------------------------------------------------------------

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-private-${local.availability_zone}"
    Tier = "private"
  }
}


# -----------------------------------------------------------------------------
# Public Route Table
# -----------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# -----------------------------------------------------------------------------
# Private Route Table
#
# No default Internet route is configured yet.
#
# Phase 1A.4 will add:
#
#   0.0.0.0/0 -> NAT/Egress Instance
#
# Until then, workloads placed in this subnet can communicate only through
# VPC-local routing.
# -----------------------------------------------------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}