module "security-group_private" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name   = var.sg-private
  vpc_id = module.vpc.vpc_id

  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp", "http-80-tcp"]

  # Custom Port Rule /Opening port 8080 for APP-3.sh 

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "10.0.0.0/16"
      description = "Allow 8080"
    }
  ]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  # Egress Rule all-all open
  egress_rules = ["all-all"]

  tags = local.common_tags

}