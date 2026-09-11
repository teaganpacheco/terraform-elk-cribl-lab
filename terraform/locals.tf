locals {
  name_prefix = "${var.project_name}-${var.environment}"

  availability_zone = data.aws_availability_zones.available.names[0]
}