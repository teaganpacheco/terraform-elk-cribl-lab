variable "aws_region" {
  description = "AWS region used to deploy the lab."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name used to identify resources belonging to this project."
  type        = string
  default     = "terraform-elk-cribl-lab"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag applied to AWS resources."
  type        = string
  default     = "teaganbhd"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the lab VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block assigned to the public egress subnet."
  type        = string
  default     = "10.10.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block assigned to the private workload subnet."
  type        = string
  default     = "10.10.20.0/24"
}

variable "nat_instance_type" {
  description = "EC2 instance type used by the NAT/egress instance."
  type        = string
  default     = "t3.micro"
}

variable "nat_private_ip" {
  description = "Static private IPv4 address assigned to the NAT/egress instance."
  type        = string
  default     = "10.10.10.10"
}

variable "linux_endpoint_instance_type" {
  description = "EC2 instance type used by the Linux endpoint."
  type        = string
  default     = "t3.micro"
}

variable "linux_endpoint_private_ip" {
  description = "Static private IPv4 address assigned to the Linux endpoint."
  type        = string
  default     = "10.10.20.10"
}

# -----------------------------------------------------------------------------
# Windows Endpoint
# -----------------------------------------------------------------------------

variable "windows_endpoint_instance_type" {
  description = "EC2 instance type used by the Windows endpoint."
  type        = string
  default     = "t3.medium"
}

variable "windows_endpoint_private_ip" {
  description = "Static private IPv4 address assigned to the Windows endpoint."
  type        = string
  default     = "10.10.20.20"
}

# -----------------------------------------------------------------------------
# Cribl Stream
# -----------------------------------------------------------------------------

variable "cribl_stream_instance_type" {
  description = "EC2 instance type used by the Cribl Stream server."
  type        = string

  # Lab-sized instance. See documentation regarding Cribl production/minimum
  # sizing before Phase 3.
  default = "t3.large"
}

variable "cribl_stream_private_ip" {
  description = "Static private IPv4 address assigned to Cribl Stream."
  type        = string
  default     = "10.10.20.30"
}

# -----------------------------------------------------------------------------
# Elastic / Kibana
# -----------------------------------------------------------------------------

variable "elastic_instance_type" {
  description = "EC2 instance type used by the Elastic/Kibana server."
  type        = string
  default     = "t3.large"
}

variable "elastic_private_ip" {
  description = "Static private IPv4 address assigned to Elastic/Kibana."
  type        = string
  default     = "10.10.20.40"
}