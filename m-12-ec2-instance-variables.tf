variable "instance_type" {
  description = "instance type"
  default = "t3.micro"
  type = string 
}

variable "instance_keypair" {
    description = "Ec2 Bastion SSH KEY"
    default = "devops"
    type = string
  
}

