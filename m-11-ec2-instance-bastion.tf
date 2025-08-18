#EC2 Bastion AZ1

module "ec2-instance_bastion-az1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"
  depends_on = [ module.vpc ]
  name = "${var.environment}-Bastion-Host-AZ1"


  ami                    = data.aws_ami.amz-2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.security-group_bastion.security_group_id]
  create_eip             = true
  #associate_public_ip_address = true
  create_security_group = false
  
  tags = local.common_tags
}



