module "security-group_private" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name   = var.sg-private
  vpc_id = module.vpc.vpc_id
 
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp" , "http-80-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  
  # Egress Rule all-all open
  egress_rules = ["all-all"] 
  
  tags = local.common_tags

}