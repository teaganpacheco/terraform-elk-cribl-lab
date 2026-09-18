# -----------------------------------------------------------------------------
# NAT / Egress EC2 Instance
# -----------------------------------------------------------------------------

resource "aws_instance" "nat" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.nat_instance_type

  subnet_id  = aws_subnet.public.id
  private_ip = var.nat_private_ip

  # Public IP assignment is explicitly enabled only for this egress host.
  # The subnet itself still has automatic public addressing disabled.
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.nat.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  # Required because this instance forwards packets on behalf of other hosts.
  source_dest_check = false

  user_data = templatefile(
    "${path.module}/scripts/nat-instance.sh.tftpl",
    {
      private_subnet_cidr = var.private_subnet_cidr
    }
  )

  user_data_replace_on_change = true

  # Require Instance Metadata Service v2.
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Avoid T3 Unlimited surplus CPU-credit charges.
  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${local.name_prefix}-nat-root"
  }

  tags = {
    Name = "${local.name_prefix}-nat"
    Role = "nat-egress"
  }

  depends_on = [
    aws_internet_gateway.main,
    aws_iam_role_policy_attachment.ec2_ssm_core
  ]
}


# -----------------------------------------------------------------------------
# Elastic IPv4 Address
#
# This provides a predictable external egress address.
# -----------------------------------------------------------------------------

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}


resource "aws_eip_association" "nat" {
  allocation_id = aws_eip.nat.id
  instance_id   = aws_instance.nat.id
}


# -----------------------------------------------------------------------------
# Private Subnet Internet Route
#
# Internet-bound traffic from the private subnet is forwarded through the
# primary ENI of the NAT instance.
# -----------------------------------------------------------------------------

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"

  network_interface_id = aws_instance.nat.primary_network_interface_id

  depends_on = [
    aws_eip_association.nat
  ]
}