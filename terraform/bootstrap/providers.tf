provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Project     = "terraform-elk-cribl-lab"
      Environment = "dev"
      ManagedBy   = "terraform"
      Owner       = "teaganbhd"
    }
  }
}