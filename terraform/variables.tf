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