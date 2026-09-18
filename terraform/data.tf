# -----------------------------------------------------------------------------
# Amazon Linux 2023
#
# AWS maintains this public SSM parameter so it always references the current
# x86_64 Amazon Linux 2023 AMI in the selected region.
# -----------------------------------------------------------------------------

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}