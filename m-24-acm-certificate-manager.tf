# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "6.1.0"
  
#   domain_name = var.domain_name
#   zone_id     = data.aws_route53_zone.mydomain.zone_id



#   validation_method = "DNS"

#   tags = local.common_tags

# }

