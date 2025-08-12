module "alb_SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  
  name   = "ALB-SG"
  vpc_id = module.vpc.vpc_id
 
  # Enabling port 80 (in this case. Can be any port, if you want to use amazon default ports)

  ingress_rules = ["http-80-tcp" , "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Enabling port 81 (custom port)

   ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

 
  tags = local.common_tags

}
