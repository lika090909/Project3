# Define Local Values in Terraform
locals {
  owners = var.business_division
  environment = var.environment
  name = "${var.business_division}-${var.environment}"
  
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
}

locals {
  ec2_private_names = {
    "0" = "Private-AZ1"
    "1" = "Private-AZ2"
  }
}

variable "domain_name" {
    description = "domain name"
    default  = "www.lalalalalalala7.com"
    type = string
}