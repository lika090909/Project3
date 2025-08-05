variable "instance_type" {
  description = "instance type"
  default = "t3.micro"
  type = string 
}

# Keypair for bastion
variable "instance_keypair" {
    description = "Ec2 Bastion SSH KEY"
    default = "devops"
    type = string
  
}

# Keypair for private ec2

variable "private-ec2-keypair" {
    description = "private ec2 keypair"
    default = "private-ec2-key"
    type = string
  
}


# # RDS variables:  

variable "rds_engine" {
  description = "RDS engine type"
  default = "mysql"
  type = string
}

variable "rds_engine_version" {
  description = "RDS engine version"
  default = "8.0.41"
  type = string

  
}

variable "instance_class" {
  description = "RDS instance class"
  default = "db.t3.micro"
  type = string
   

}

variable "allocated_storage" {
  description = "RDS disk size in GB"
  default = 20
  type = number

}

variable "storage_type" {
  description = "RDS storage type"
  default = "gp2"
  type = string
  
}

variable "username" {
  description = "RDS DB username"
  default = "devops"
  type = string 
  
}

variable "password" {
  description = "RDS DB password"
  default = "password123"
  type = string 
  
}
