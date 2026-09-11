output "aws_account_id" {
  description = "AWS account in which Terraform is operating."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region used by the lab."
  value       = var.aws_region
}

output "availability_zone" {
  description = "Availability Zone selected for the development lab."
  value       = local.availability_zone
}