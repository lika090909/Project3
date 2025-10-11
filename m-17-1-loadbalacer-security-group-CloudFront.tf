module "alb_SG" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name   = "ALB-SG"
  vpc_id = module.vpc.vpc_id

  ingress_with_prefix_list_ids = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      description     = "Allow HTTP from CloudFront"
      prefix_list_ids = "pl-3b927c52"
    },
    {
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      description     = "Allow HTTP:8080 from CloudFront"
      prefix_list_ids = "pl-3b927c52"
    },
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      description     = "Allow HTTPS from CloudFront"
      prefix_list_ids = "pl-3b927c52"
    }
  ]

  egress_rules = ["all-all"]

  tags = local.common_tags
}
