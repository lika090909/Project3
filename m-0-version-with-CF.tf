terraform {
  required_version = ">= 1.11.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12, < 7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

# Default AWS provider
provider "aws" {
  profile = var.aws_credential_profile
  region  = var.aws_region
}

# Secondary provider for us-east-1 (needed for ACM/CloudFront certs)
provider "aws" {
  alias   = "us_east_1"
  profile = var.aws_credential_profile
  region  = "us-east-1"
}
