module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = var.vpc_name
  cidr = var.vpc_cidr_block
  azs  = var.vpc_az
  private_subnets     = var.vpc_private_subnet
  public_subnets      = var.vpc_public_subnet
  private_subnet_names = ["Private Subnet AZ-1", "Private Subnet AZ-2"]
  public_subnet_names = ["Public Subnet AZ-1", "Public Subnet AZ-2"]
  default_route_table_name = "dev-default-route-table"

  # Database Info

  create_database_subnet_group = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  database_subnet_names    = ["DB Subnet AZ-1" , "DB Subnet AZ-2"]
  database_subnets    = var.vpc_database_subnets
  
 
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false
  nat_gateway_tags = {
    Name = "dev-nat-gateway"
  }

  tags = local.common_tags
  #vpc_tags = local.common_tags

  # Additional Tags to Subnets
  public_subnet_tags = {
    Type = "Public Subnets"
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  }  
  database_subnet_tags = {
    Type = "Private Database Subnets"
  }

}