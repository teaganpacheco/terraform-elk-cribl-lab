# -----------------------------------------------------------------------------
# Linux Endpoint
#
# Ubuntu 24.04 LTS endpoint used initially to validate private networking,
# Systems Manager access, NAT egress, DNS, and baseline EC2 hardening.
#
# Phase 2 will extend this instance with Cribl Edge.
# -----------------------------------------------------------------------------

resource "aws_instance" "linux_endpoint" {
  ami           = data.aws_ssm_parameter.ubuntu_2404_ami.insecure_value
  instance_type = var.linux_endpoint_instance_type

  subnet_id  = aws_subnet.private.id
  private_ip = var.linux_endpoint_private_ip

  # Private workload: never assign a public IPv4 address.
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.linux_endpoint.id
  ]

  # Reuse the SSM role/profile created during Phase 1A.4.
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  # Require IMDSv2.
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Avoid T3 Unlimited surplus-credit charges.
  credit_specification {
    cpu_credits = "standard"
  }

  # Keep detailed monitoring disabled for this cost-conscious development lab.
  monitoring = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 12
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${local.name_prefix}-linux-endpoint-root"
  }

  tags = {
    Name = "${local.name_prefix}-linux-endpoint"
    Role = "endpoint"
    OS   = "ubuntu"
  }

  depends_on = [
    aws_route.private_internet,
    aws_iam_role_policy_attachment.ec2_ssm_core
  ]
}

# -----------------------------------------------------------------------------
# Windows Endpoint
#
# Windows Server 2022 endpoint that will receive Cribl Edge, Sysmon, and other
# endpoint telemetry configuration during Phase 2.
# -----------------------------------------------------------------------------

resource "aws_instance" "windows_endpoint" {
  ami           = data.aws_ssm_parameter.windows_2022_ami.insecure_value
  instance_type = var.windows_endpoint_instance_type

  subnet_id  = aws_subnet.private.id
  private_ip = var.windows_endpoint_private_ip

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.windows_endpoint.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  monitoring = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 40
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${local.name_prefix}-windows-endpoint-root"
  }

  tags = {
    Name = "${local.name_prefix}-windows-endpoint"
    Role = "endpoint"
    OS   = "windows"
  }

  depends_on = [
    aws_route.private_internet,
    aws_iam_role_policy_attachment.ec2_ssm_core
  ]
}

# -----------------------------------------------------------------------------
# Cribl Stream Server
#
# Ubuntu 24.04 host reserved for the single-instance Cribl Stream deployment.
# Application installation and Stream networking are deferred to Phase 3.
# -----------------------------------------------------------------------------

resource "aws_instance" "cribl_stream" {
  ami           = data.aws_ssm_parameter.ubuntu_2404_ami.insecure_value
  instance_type = var.cribl_stream_instance_type

  subnet_id  = aws_subnet.private.id
  private_ip = var.cribl_stream_private_ip

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.cribl_stream.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  monitoring = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${local.name_prefix}-cribl-stream-root"
  }

  tags = {
    Name = "${local.name_prefix}-cribl-stream"
    Role = "telemetry-pipeline"
    OS   = "ubuntu"
  }

  depends_on = [
    aws_route.private_internet,
    aws_iam_role_policy_attachment.ec2_ssm_core
  ]
}

# -----------------------------------------------------------------------------
# Elastic / Kibana Server
#
# Single-node lab analytics host. Elasticsearch and Kibana installation and
# configuration are deferred to Phase 4.
# -----------------------------------------------------------------------------

resource "aws_instance" "elastic" {
  ami           = data.aws_ssm_parameter.ubuntu_2404_ami.insecure_value
  instance_type = var.elastic_instance_type

  subnet_id  = aws_subnet.private.id
  private_ip = var.elastic_private_ip

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.elastic.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  monitoring = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    encrypted             = true
    delete_on_termination = true
  }

  volume_tags = {
    Name = "${local.name_prefix}-elastic-root"
  }

  tags = {
    Name = "${local.name_prefix}-elastic"
    Role = "security-analytics"
    OS   = "ubuntu"
  }

  depends_on = [
    aws_route.private_internet,
    aws_iam_role_policy_attachment.ec2_ssm_core
  ]
}