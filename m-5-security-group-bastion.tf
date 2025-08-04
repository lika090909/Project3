module "security-group_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name   = var.sg-bastion
  vpc_id = module.vpc.vpc_id
 
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

 
  tags = local.common_tags

}



