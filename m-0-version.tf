#Terraform Blockcheck 

terraform {
  required_version = "1.11.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = ">=6.6.0"
      version = ">= 6.12, < 7.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = var.aws_credential_profile
  region = var.aws_region
}


