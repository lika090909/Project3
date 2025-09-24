
#VPC NAME 

variable "vpc_name" {
  description = "VPC Name"
  default     = "vpc-dev"
  type        = string

}

#CIDR BLOCK 

variable "vpc_cidr_block" {
  description = "VPC Cidr Block"
  default     = "10.0.0.0/16"
  type        = string

}

#Availablity Zone 

variable "vpc_az" {
  description = "VPC Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(string)

}

#Public Subnet for Bastion Host

variable "vpc_public_subnet" {
  description = "VPC Public Subnet"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  type        = list(string)

}

#Private Subnet for EC2s

variable "vpc_private_subnet" {
  description = "VPC Private Subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  type        = list(string)

}

#Private Database Subnet 

variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
  type        = list(string)
}

#VPC Create Database Subnet Group (True / False) 

variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}
